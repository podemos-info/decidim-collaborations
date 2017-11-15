# frozen_string_literal: true

module Decidim
  module Collaborations
    # Helper methods for totals partial
    module TotalsHelper
      # PUBLIC: Generates the ID for the totals block.
      def totals_block_id(user)
        return 'overall-totals-block' if user.nil?
        "overall-totals-user-#{user.id}"
      end

      # PUBLIC: Generate title for totals block. The result may vary depending
      # on the totals scope: global or user.
      def totals_title(user)
        if user.nil?
          return I18n.t('overall_totals',
                        scope: 'decidim.collaborations.collaborations.totals')
        end

        I18n.t('user_totals', scope: 'decidim.collaborations.collaborations.totals')
      end

      # PUBLIC: Retrieves total collected depending on the context for totals
      # block
      def total_collected(collaboration, user)
        if user.nil?
          return decidim_number_to_currency collaboration.total_collected
        end

        decidim_number_to_currency collaboration.user_total_collected(user)
      end

      # PUBLIC: Returns percentage value formatted as a percentage without
      # decimal places.
      def percentage(collaboration, user)
        number_to_percentage percentage_value(collaboration, user), precision: 0
      end

      # PUBLIC: Returns the percentage value over the objective amount: If user
      # is nil it will return the overall percentage
      def percentage_value(collaboration, user)
        return collaboration.percentage if user.nil?
        collaboration.user_percentage(user)
      end

      # PUBLIC: Generates a tag that represents the current percentage with
      # regards to the target objective of the campaign.
      # When user is nil it represents the overall percentage. Otherwise it
      # represents the user percentage.
      def percentage_tag(collaboration, user)
        css_class = percentage_class(percentage_value(collaboration, user))

        content_tag(:div, class: "extra__percentage percentage #{css_class}".strip) do
          5.times do
            concat(content_tag(:span, class: 'percentage__item') {})
          end

          concat(content_tag(:span, class: 'percentage__desc') do
            decidim_number_to_currency(collaboration.target_amount)
            I18n.t(
              'decidim.collaborations.collaborations.totals.target_amount',
              amount: decidim_number_to_currency(collaboration.target_amount)
            )
          end)
        end
      end

      # PUBLIC returns the percentage CSS class to apply for a given
      # percentage value.
      def percentage_class(percentage)
        return '' if percentage.blank?
        return 'percentage--level1' if percentage >= 0 && percentage < 40
        return 'percentage--level2' if percentage >= 40 && percentage < 60
        return 'percentage--level3' if percentage >= 60 && percentage < 80
        return 'percentage--level4' if percentage >= 80 && percentage < 100
        return 'percentage--level5' if percentage >= 100

        ''
      end
    end
  end
end