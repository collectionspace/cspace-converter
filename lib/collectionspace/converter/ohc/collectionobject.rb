module CollectionSpace
  module Converter
    module OHC
      class OHCCollectionObject < AnthroCollectionObject
        ::OHCCollectionObject = CollectionSpace::Converter::OHC::OHCCollectionObject
        def convert
          run(wrapper: 'document') do |xml|
            xml.send(
              "ns2:collectionobjects_common",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              CoreCollectionObject.map(xml, clean_overridden_attributes)
              OHCCollectionObject.map_common_overrides(xml, attributes)
            end

            xml.send(
              "ns2:collectionobjects_anthro",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/anthro",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              AnthroCollectionObject.map(xml, clean_overridden_attributes)
            end

            xml.send(
              "ns2:collectionobjects_ohc",
              "xmlns:ns2" => "http://collectionspace.org/services/collectionobject/domain/ohc",
              "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              OHCCollectionObject.map(xml, attributes)
            end
          end
        end #def convert

        # This is used instead of the redefined_fields method because using that method did not
        #  work here, where ohc calls both anthro and core, and both ohc an anthro override different
        #  core field conversion behavior. Using redefined_fields in ohc was resulting in only
        #  anthro's overrides being applied. 
        def clean_overridden_attributes
          overridden = [
            'assocpeople',
            'assocpeopletype',
            'assocpeoplenote',
            'objectnametype',
            'objectnamesystem',
            'objectname',
            'objectnamecurrency',
            'objectnamenote',
            'objectnamelevel',
            'objectnamelanguage'
          ]
          safe = attributes.clone
          overridden.each{ |fieldname| safe.delete(fieldname) }
          return safe
        end

        def self.map_common_overrides(xml, attributes)
          # assocPeopleGroupList , assocPeopleGroup
          assocpeopledata = {
            'assocpeople' => 'assocPeople',
            'assocpeopletype' => 'assocPeopleType',
            'assocpeoplenote' => 'assocPeopleNote'
          }
          aptransform = {
            'assocpeople' => {'authority' => ['conceptauthorities', 'ethculture']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'assocPeople',
            assocpeopledata,
            aptransform
          )

          # objectNameList, objectNameGroup
          obj_name_data = {
            'objectnametype' => 'objectNameType',
            'objectnamesystem' => 'objectNameSystem',
            'objectname' => 'objectName',
            'objectnamecurrency' => 'objectNameCurrency',
            'objectnamenote' => 'objectNameNote',
            'objectnamelevel' => 'objectNameLevel',
            'objectnamelanguage' => 'objectNameLanguage'
          }
          obj_name_transforms = {
            'objectnamelanguage' => {'vocab' => 'languages'},
            'objectname' => {'authority' => ['conceptauthorities', 'nomenclature']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'objectName',
            obj_name_data,
            obj_name_transforms,
            list_suffix: 'List'
          )
        end

        def self.map(xml, attributes)
          pairs = {
            'descriptionlevel' => 'descriptionLevel'
          }
          pair_transforms = {
            'descriptionlevel' => {'vocab' => 'descriptionlevel'}
          }
          CSXML::Helpers.add_pairs(xml, attributes, pairs, pair_transforms)

          repeats = {
            'namedtimeperiod' => ['namedTimePeriods', 'namedTimePeriod']
          }
          repeat_transforms = {
            'namedtimeperiod' => {'vocab' => 'namedtimeperiods'}
          }
          CSXML::Helpers.add_repeats(xml, attributes, repeats, repeat_transforms)

          #oaiSiteGroupList, oaiSiteGroup
          oai_data = {
            'oaicollectionplace' => 'oaiCollectionPlace',
            'oailocverbatim' => 'oaiLocVerbatim'
          }
          oai_transforms = {
            'oaicollectionplace' => {'authority' => ['placeauthorities', 'place']}
          }
          CSXML.add_single_level_group_list(
            xml,
            attributes,
            'oaiSite',
            oai_data,
            oai_transforms
            )
        end
        
      end #class OHCCollectionObject
    end #module OHC
  end #module Converter
end #module CollectionSpace