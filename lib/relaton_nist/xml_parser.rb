module RelatonNist
  class XMLParser < RelatonBib::XMLParser
    class << self
      def from_xml(xml)
        doc = Nokogiri::XML xml
        doc.remove_namespaces!
        nistitem = doc.at("/bibitem|/bibdata")
        if nistitem
          NistBibliographicItem.new(item_data(nistitem))
        elsif
          warn "[relaton-nist] can't find bibitem or bibdata element in the XML"
        end
      end

      private

      def item_data(nistitem)
        data = super
        ext = nistitem.at "./ext"
        return data unless ext

        data[:commentperiod] = fetch_commentperiod(ext)
        data
      end

      def fetch_status(item)
        status = item.at "./status"
        return unless status

        DocumentStatus.new(
          stage: status.at("stage")&.text,
          substage: status.at("substage")&.text,
          iteration: status.at("iteration")&.text,
        )
      end

      def fetch_commentperiod(item)
        cp = item.at "./commentperiod"
        return unless cp

        CommentPeriod.new(
          from: cp.at("from").text, to: cp.at("to")&.text,
          extended: cp.at("extended")&.text
        )
      end

      # @param item [Nokogiri::XML::Element]
      # @return [Array<RelatonBib::DocumentRelation>]
      def fetch_relations(item)
        item.xpath("./relation").map do |rel|
          DocumentRelation.new(
            type: rel[:type]&.empty? ? nil : rel[:type],
            description: relation_description(rel),
            bibitem: bib_item(item_data(rel.at("./bibitem"))),
            locality: localities(rel),
            source_locality: source_localities(rel),
          )
        end
      end
    end
  end
end
