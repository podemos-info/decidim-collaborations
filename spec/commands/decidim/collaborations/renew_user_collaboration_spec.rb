# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Collaborations
    describe RenewUserCollaboration do
      let!(:user_collaboration) do
        create(
          :user_collaboration,
          :annual,
          :accepted,
          last_order_request_date: Date.today - 11.months - 1.day
        )
      end

      subject { described_class.new(user_collaboration) }

      context 'valid?' do
        context 'Collaboration do not accepts supports' do
          before do
            allow(user_collaboration.collaboration).to receive(:accepts_supports?).and_return(false)
          end

          it 'is not valid' do
            expect { subject.call }.to broadcast(:invalid)
          end
        end

        context 'Census API is down' do
          before do
            stub_totals_service_down
          end

          it 'is not valid' do
            expect { subject.call }.to broadcast(:invalid)
          end
        end

        context 'User has reached the maximum allowed' do
          before do
            stub_totals_request(Decidim::Collaborations.maximum_annual_collaboration)
          end

          it 'is not valid' do
            expect { subject.call }.to broadcast(:invalid)
          end
        end
      end

      context 'Census service is down' do
        before do
          stub_orders_service_down
        end

        it 'do not updates the collaboration' do
          subject.call
          user_collaboration.reload
          expect(user_collaboration.last_order_request_date).not_to eq(Date.today.beginning_of_month)
        end

        it 'is not valid' do
          expect { subject.call }.to broadcast(:invalid)
        end
      end

      context 'Census API rejects the request' do
        before do
          stub_totals_request(0)
          stub_orders(422, { errorCode: 1, errorMessage: 'Error message'})
        end

        it 'do not updates the collaboration' do
          subject.call
          user_collaboration.reload
          expect(user_collaboration.last_order_request_date).not_to eq(Date.today.beginning_of_month)
        end

        it 'is not valid' do
          expect { subject.call }.to broadcast(:invalid)
        end
      end

      context 'when everything is ok' do
        let(:json) do
          { payment_method_id: user_collaboration.payment_method_id }
        end

        before do
          stub_orders(201, json)
          stub_totals_request(0)
          subject.call
          user_collaboration.reload
        end

        it 'last_order_request_date is updated' do
          expect(user_collaboration.last_order_request_date).to eq(Date.today.beginning_of_month)
        end
      end
    end
  end
end
