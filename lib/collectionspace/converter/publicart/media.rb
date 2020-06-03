module CollectionSpace
  module Converter
    module PublicArt
      class PublicArtMedia < Media
        ::PublicArtMedia = CollectionSpace::Converter::PublicArt::PublicArtMedia
        def convert
          run(wrapper: "document") do |xml|
            xml.send(
                "ns2:media_common",
                "xmlns:ns2" => "http://collectionspace.org/services/media",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              CoreMedia.map(xml, attributes)
            end

            xml.send(
                "ns2:media_publicart",
                "xmlns:ns2" => "http://collectionspace.org/services/media/local/publicart",
                "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance"
            ) do
              xml.parent.namespace = nil
              PublicArtMedia.extension(xml, attributes)
            end
          end
        end

        def self.extension(xml, attributes)
          #
          # publicartRightsHolders (two CSV columns, rights_holder_org and owners_org)
          #
          rightsholders_urns = []
          rightsholders = CSXML.split_mvf attributes, 'rightsholder_person'
          rightsholders.each do | rightsholder |
            rightsholders_urns << { "publicartRightsHolder" => CSURN.get_authority_urn('personauthorities', 'person', rightsholder) }
          end
          rightsholders = CSXML.split_mvf attributes, 'rightsholder_org'
          rightsholders.each do |rightsholder|
            rightsholders_urns << { "publicartRightsHolder" => CSURN.get_authority_urn('orgauthorities', 'organization', rightsholder) }
          end
          CSXML.add_repeat(xml, 'publicartRightsHolders', rightsholders_urns) if rightsholders_urns.empty? == false

          #
          # publishToList
          #
          publishto_urns = []
          publishto_list = CSXML.split_mvf attributes, 'publishto'
          publishto_list.each do | publishto |
            publishto_urns << { "publishTo" => CSURN.get_vocab_urn('publishto', publishto) }
          end
          if publishto_urns.empty? == false
            puts publishto_urns
          end
          CSXML.add_repeat(xml, 'publishToList', publishto_urns) if publishto_urns.empty? == false
        end

        def self.map(xml, attributes)
          # n/a
        end
      end
    end
  end
end
