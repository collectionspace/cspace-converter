module CollectionSpace
  module Converter
    module Core
      class CoreConcept < Concept
        ::CoreConcept = CollectionSpace::Converter::Core::CoreConcept
        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              'ns2:concepts_common',
              'xmlns:ns2' => 'http://collectionspace.org/services/concept',
              'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance'
            ) do
              xml.parent.namespace = nil
              CoreConcept.map(xml, attributes, config)
            end            
          end
        end

        def self.map(xml, attributes, config)
          CSXML.add xml, 'shortIdentifier', config[:identifier]

          pairs = {
            'scopenote' => 'scopeNote',
            'scopenotesource' => 'scopeNoteSource',
            'scopenotesourcedetail' => 'scopeNoteSourceDetail',
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs)
          
          repeats = {
            'conceptrecordtype' => ['conceptRecordTypes', 'conceptRecordType']
          }
          repeat_transforms = {
            'conceptrecordtype' => {'vocab' => 'concepttype'}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeat_transforms)

          # conceptTermGroupList
          term_data = {
            'termdisplayname' => 'termDisplayName',
            'termname' => 'termName',
            'termqualifier' => 'termQualifier',
            'termstatus' => 'termStatus',
            'termtype' => 'termType',
            'termflag' => 'termFlag',
            'historicalstatus' => 'historicalStatus',
            'termlanguage' => 'termLanguage',
            'termprefforlang' => 'termPrefForLang',
            'termsource' => 'termSource',
            'termsourcedetail' => 'termSourceDetail',
            'termsourceid' => 'termSourceID',
            'termsourcenote' => 'termSourceNote'
          }
          term_transforms = {
            'termsource' => {'authority' => ['citationauthorities', 'citation']},
            'termflag' => {'vocab' => 'concepttermflag'},
            'termlanguage' => {'vocab' => 'languages'},
            'termprefforlang' => {'special' => 'boolean'}
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'conceptTerm',
            term_data,
            term_transforms
            )

          # citationGroupList
          citation_data = {
            'citationsource' => 'citationSource',
            'citationsourcedetail' => 'citationSourceDetail',
          }
          CSXML.add_single_level_group_list(
            xml, attributes,
            'citation',
            citation_data
          )

          # additionalSourceGroupList
          src_data = {
            'additionalsource' => 'additionalSource',
            'additionalsourcenote' => 'additionalSourceNote',
            'additionalsourcedetail' => 'additionalSourceDetail',
            'additionalsourceid' => 'additionalSourceID'}
          CSXML.add_single_level_group_list(
            xml, attributes,
            'additionalSource',
            src_data
          )
        end
      end
    end
  end
end
