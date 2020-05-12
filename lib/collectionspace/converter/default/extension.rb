# frozen_string_literal: true

module CollectionSpace
  module Converter
    module Default
      module Extension
        ::Extension = CollectionSpace::Converter::Default::Extension

        def self.map_cultural_care(xml, attributes)
          repeats = {
            'culturalcarenote' => %w[culturalCareNotes culturalCareNote]
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats)

          # accessLimitationsGroupList, accessLimitationsGroup
          aldata = {
            'limitationdetails' => 'limitationDetails',
            'limitationlevel' => 'limitationLevel',
            'limitationtype' => 'limitationType',
            'requestdate' => 'requestDate',
            'requester' => 'requester',
            'requestonbehalfof' => 'requestOnBehalfOf'
          }
          altransforms = {
            'limitationlevel' => { 'vocab' => 'limitationlevel' },
            'limitationtype' => { 'vocab' => 'limitationtype' },
            'requester' => { 'authority' => %w[personauthorities person] },
            'requestonbehalfof' => { 'authority' => %w[orgauthorities organization] },
            'requestdate' => { 'special' => 'unstructured_date_stamp' }
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'accessLimitations',
            aldata,
            altransforms
          )
        end
      end
    end
  end
end
