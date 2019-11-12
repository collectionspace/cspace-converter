module CollectionSpace
  module Tools
    class XML
      ::CSXML = CollectionSpace::Tools::XML

      def self.add(xml, key, value)
        xml.send(key.to_sym, value)
      end

      # add data from ruby hash containing array of elements (see spec)
      def self.add_data(xml, data = [])
        ::CSXML.process_array(xml, data['label'], data['elements'])
      end

      def self.add_group(xml, key, elements = {})
        xml.send("#{key}Group".to_sym) {
          elements.each {|k, v| xml.send(k.to_sym, v)}
        }
      end

      # TODO: higher level method to introspect types and build xml
      # TODO: refactor, sub_elements as array of hashes to reconcile uses of sub_key
      def self.add_group_list(xml, key, elements = [], sub_key = false, sub_elements = [], include_group_prefix: true)
        group_prefix = "List"
        if include_group_prefix
          group_prefix = "GroupList"
        end

        xml.send("#{key}#{group_prefix}".to_sym) {
          elements.each_with_index do |element, index|
            xml.send("#{key}Group".to_sym) {
              element.each {|k, v| xml.send(k.to_sym, v)}
              if sub_key
                xml.send("#{sub_key}SubGroupList".to_sym) {
                  sub_elements.each do |sub_element|
                    xml.send("#{sub_key}SubGroup".to_sym) {
                      sub_element.each {|k, v| xml.send(k.to_sym, v)}
                    }
                  end
                }
              elsif sub_elements
                next unless sub_elements[index]
                sub_elements[index].each do |type, sub_element|
                  if sub_element.respond_to? :each
                    xml.send(type.to_sym) {
                      sub_element.each {|k, v| xml.send(k.to_sym, v)}
                    }
                  else
                    xml.send(type, sub_element)
                  end
                end
              end
            }
          end
        }
      end

      # key_suffix handles the case that the list child element is not the key without "List"
      # for example: key=objectName, list=objectNameList, key_suffix=Group, child=objectNameGroup
      def self.add_list(xml, key, elements = [], key_suffix = '')
        xml.send("#{key}List".to_sym) {
          elements.each do |element|
            xml.send("#{key}#{key_suffix}".to_sym) {
              element.each {|k, v| xml.send(k.to_sym, v)}
            }
          end
        }
      end

      def self.add_repeat(xml, key, elements = [], key_suffix = '')
        xml.send("#{key}#{key_suffix}".to_sym) {
          elements.each do |element|
            element.each {|k, v| xml.send(k.to_sym, v)}
          end
        }
      end

      def self.add_string(xml, string)
        xml << string
      end

      def self.process_array(xml, label, array)
        array.each do |hash|
          xml.send(label) do
            hash.each do |key, value|
              if value.is_a?(Array)
                ::CSXML.process_array(xml, key, value)
              else
                xml.send(key, value)
              end
            end
          end
        end
      end

      module Helpers

        def self.add_authority(xml, field, authority_type, authority, value)
          return nil unless value

          CSXML.add xml, field, CSURN.get_authority_urn(authority_type, authority, value)
        end

        def self.add_authorities(xml, field, authority_type, authority, values = [], method)
          values = values.compact.map do |value|
            {
                field => CSURN.get_authority_urn(authority_type, authority, value),
            }
          end
          return nil unless values.any?

          # we are crudely forcing pluralization for repeats (this may need to be revisited)
          # sometimes the parent and child elements are both pluralized so ensure there's only 1 i.e.
          # conservators: [ "conservators" ... ] vs. acquisitionSources: [ "acquisitionSource" ... ]
          field_wrapper = method == :add_repeat ? "#{field}s".gsub(/ss$/, "s") : field
          CSXML.send(method, xml, field_wrapper, values)
        end

        def self.add_concept(xml, field, value)
          add_authority xml, field, 'conceptauthorities', 'concept', value
        end

        def self.add_concepts(xml, field, values = [], method = :add_group_list)
          add_authorities xml, field, 'conceptauthorities', 'concept', values, method
        end

        def self.add_date_group(xml, field, date)
          CSXML.add_group xml, field, CSDTP.fields_for(date)
        end

        def self.add_date_group_list(xml, field, dates)
          dates = dates.map { |d| CSDTP.fields_for(d) }
          CSXML.add_group_list xml, field, dates
        end

        def self.add_location(xml, field, value)
          add_authority xml, field, 'locationauthorities', 'location', value
        end

        def self.add_locations(xml, field, values = [], method = :add_group_list)
          add_authorities xml, field, 'locationauthorities', 'location', values, method
        end

        def self.add_material(xml, field, value)
          add_authority xml, field, 'materialauthorities', 'material', value
        end

        def self.add_materials(xml, field, values = [], method = :add_group_list)
          add_authorities xml, field, 'materialauthorities', 'material', values, method
        end

        def self.add_measured_part_group_list(xml, attributes)
          overall_data = {
            "measuredPart" => attributes["measuredpart"],
            "dimensionSummary" => attributes["dimensionsummary"],
          }
          dimensions = []
          dims = CSDR.split_mvf attributes, 'dimension'
          values = CSDR.split_mvf attributes, 'value'
          unit = attributes["measurementunit"]
          by = CSXML::Helpers.get_authority(
            'personauthorities', 'person', attributes["measuredby"]
          )
          method = attributes["measurementmethod"]
          date = CSDTP.parse(attributes["valuedate"]).earliest_scalar
          qualifier = attributes["valuequalifier"]
          note = attributes["dimensionnote"]
          dims.each_with_index do |dim, index|
            dimensions << {
              "dimension" => dim,
              "value" => values[index],
              "measurementUnit" => unit,
              "measuredBy" => by,
              "measurementMethod" => method,
              "valueDate" => date,
              "valueQualifier" => qualifier,
              "dimensionNote" => note
            }
          end
          CSXML.add_group_list xml, 'measuredPart', [overall_data], 'dimension', dimensions
        end

        def self.add_pairs(xml, attributes, pairs)
          return nil unless pairs

          pairs.each do |attribute, field|
            field = "#{field}_" if reserved?(field)
            CSXML.add(xml, field, attributes[attribute])
          end
        end

        def self.add_person(xml, field, value)
          add_authority xml, field, 'personauthorities', 'person', value
        end

        def self.add_persons(xml, field, values = [], method = :add_group_list)
          add_authorities xml, field, 'personauthorities', 'person', values, method
        end

        def self.add_organization(xml, field, value)
          add_authority xml, field, 'orgauthorities', 'organization', value
        end

        def self.add_organizations(xml, field, values = [], method = :add_group_list)
          add_authorities xml, field, 'orgauthorities', 'organization', values, method
        end

        def self.add_place(xml, field, value)
          add_authority xml, field, 'placeauthorities', 'place', value
        end

        def self.add_places(xml, field, values = [], method = :add_group_list)
          add_authorities xml, field, 'placeauthorities', 'place', values, method
        end

        def self.add_simple_groups(xml, attributes, groups)
          return unless groups

          groups.each do |attribute, field|
            values = safe_split(field, attributes, attribute)
            CSXML.add_group_list xml, field, values
          end
        end

        def self.add_simple_repeats(xml, attributes, repeats)
          return unless repeats

          repeats.each do |attribute, field|
            values = safe_split(field, attributes, attribute)
            CSXML.add_repeat xml, field, values
          end
        end

        def self.add_taxon(xml, field, value)
          add_authority xml, field, 'taxonomyauthority', 'taxon', value
        end

        def self.add_title(xml, attributes)
          if attributes["titletranslation"]
            CSXML.add_group_list xml, 'title', [
              {
              "title" => attributes["title"],
              "titleLanguage" => CSXML::Helpers.get_vocab('languages', attributes["titlelanguage"]),
              }
            ], 'titleTranslation', [
              {
                "titleTranslation" => attributes["titletranslation"],
                "titleTranslationLanguage" => CSXML::Helpers.get_vocab('languages', attributes["titletranslationlanguage"])
              }
            ]
          elsif attributes["titlelanguage"]
            CSXML.add_group_list xml, 'title', [{
              "title" => attributes["title"],
              "titleLanguage" => CSXML::Helpers.get_vocab('languages', attributes["titlelanguage"]),
            }]
          else
            CSXML.add_group_list xml, 'title', [{
              "title" => attributes["title"],
            }]
          end
        end

        def self.add_vocab(xml, field, vocabulary, value)
          return nil unless value

          CSXML.add xml, field, CSURN.get_vocab_urn(vocabulary, value)
        end

        def self.get_authority(authority_type, authority, value)
          return nil unless value

          CSURN.get_authority_urn(authority_type, authority, value)
        end

        def self.get_vocab(vocabulary, value)
          return nil unless value

          CSURN.get_vocab_urn(vocabulary, value)
        end

        # TODO: config
        def self.reserved?(field)
          ['comment', 'format'].include?(field)
        end

        def self.safe_split(field, attributes, attribute)
          subfield = field.singularize
          subfield = "#{subfield}_" if reserved?(subfield)
          CSDR.split_mvf(attributes, attribute).map do |p|
            {
              subfield => p
            }
          end
        end

        def self.shortid_for_auth(type, subtype, value)
          refname = CSXML::Helpers.get_authority(type, subtype, value)
          CSURN.parse(refname)[:identifier] if refname
        end

        def self.shortid_for_vocab(vocabulary, value)
          refname = CSXML::Helpers.get_vocab(vocabulary, value)
          CSURN.parse(refname)[:identifier] if refname
        end
      end
    end
  end
end
