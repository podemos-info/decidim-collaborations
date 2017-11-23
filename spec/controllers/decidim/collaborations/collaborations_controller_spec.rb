# frozen_string_literal: true

require 'spec_helper'

module Decidim
  module Collaborations
    describe CollaborationsController, type: :controller do
      routes { Decidim::Collaborations::Engine.routes }

      before do
        @request.env['decidim.current_organization'] = feature.organization
        @request.env['decidim.current_feature'] = feature
      end

      let(:feature) { create :collaboration_feature }
      let(:params) do
        {
          feature_id: feature.id,
          participatory_process_slug: feature.participatory_space.slug
        }
      end

      context 'index' do
        context 'one collaboration' do
          let!(:collaboration) { create(:collaboration, feature: feature) }
          let(:path) do
            collaboration_path(
              feature_id: params[:feature_id],
              participatory_process_slug: params[:participatory_process_slug],
              id: collaboration.id
            )
          end

          it 'redirects to the collaboration page' do
            get :index, params: params
            expect(response).to redirect_to(path)
          end
        end

        context 'several collaborations' do
          let!(:collaborations) { create_list(:collaboration, 2, feature: feature) }

          it 'redirects to the collaboration page' do
            get :index, params: params
            expect(response).to have_http_status(200)
          end
        end
      end
    end
  end
end