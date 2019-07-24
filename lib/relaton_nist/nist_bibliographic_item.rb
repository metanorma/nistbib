module RelatonNist
  class NistBibliographicItem < RelatonBib::BibliographicItem
    # @return [String]
    attr_reader :doctype

    # @return [Array<RelatonNist::Keyword>]
    attr_reader :keyword

    # @return [RelatonNist::CommentPeriod]
    attr_reader :commentperiod

    # @param id [String, NilClass]
    # @param title [Array<RelatonBib::TypedTitleString>]
    # @param formattedref [RelatonBib::FormattedRef, NilClass]
    # @param type [String, NilClass]
    # @param docid [Array<RelatonBib::DocumentIdentifier>]
    # @param docnumber [String, NilClass]
    # @param language [Arra<String>]
    # @param script [Array<String>]
    # @param docstatus [RelatonNist::DocumentStatus, NilClass]
    # @param edition [String, NilClass]
    # @param version [RelatonBib::BibliographicItem::Version, NilClass]
    # @param biblionote [Array<RelatonBib::FormattedStrong>]
    # @param series [Array<RelatonBib::Series>]
    # @param medium [RelatonBib::Medium, NilClas]
    # @param place [Array<String>]
    # @param extent [Array<Relaton::BibItemLocality>]
    # @param accesslocation [Array<String>]
    # @param classification [RelatonBib::Classification, NilClass]
    # @param validity [RelatonBib:Validity, NilClass]
    # @param fetched [Date, NilClass] default nil
    # @param doctype [String]
    # @param keyword [Array<RelatonNist::Keyword>]
    # @param commentperiod [RelatonNist::CommentPeriod]
    #
    # @param date [Array<Hash>]
    # @option date [String] :type
    # @option date [String] :from
    # @option date [String] :to
    #
    # @param contributor [Array<Hash>]
    # @option contributor [String] :type
    # @option contributor [String] :from
    # @option contributor [String] :to
    # @option contributor [String] :abbreviation
    # @option contributor [Array<String>] :role
    #
    # @param abstract [Array<Hash>]
    # @option abstract [String] :content
    # @option abstract [String] :language
    # @option abstract [String] :script
    # @option abstract [String] :type
    #
    # @param relation [Array<Hash>]
    # @option relation [String] :type
    # @option relation [RelatonBib::BibliographicItem] :bibitem
    # @option relation [Array<RelatonBib::BibItemLocality>] :bib_locality
    def initialize(**args)
      @doctype = args.delete(:doctype) || "standard"
      @keyword = args.delete(:keyword) || []
      @commentperiod = args.delete :commentperiod
      super
    end

    # @param builder [Nokogiri::XML::Builder]
    def to_xml(builder = nil, **opts)
      super builder, date_format: :short, **opts do |b|
        if opts[:bibdata]
          b.ext do
            b.doctype doctype
            keyword.each { |kw| kw.to_xml b }
            commentperiod&.to_xml b
          end
        end
      end
    end
  end
end