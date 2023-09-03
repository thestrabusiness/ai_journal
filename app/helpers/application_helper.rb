module ApplicationHelper
  def icon(name, options = {})
    if options[:class].present?
      options[:class] += " base-icon"
    else
      options[:class] = "base-icon"
    end

    inline_svg name, options
  end

  def inline_svg(svg_name, options = {})
    filename = "#{svg_name}.svg"
    svg_source = Rails
      .application
      .assets_manifest
      .find_sources(filename)
      .first

    raise "Could not find asset \"#{filename}\"" unless svg_source

    doc = Nokogiri::HTML::DocumentFragment.parse svg_source
    svg = doc.at_css "svg"
    svg["class"] = options[:class] if options[:class].present?
    options[:data]&.each do |key, value|
      dashed_key = key.to_s.tr("_", "-")
      svg["data-#{dashed_key}"] = value
    end

    raw doc
  end

  def question_text_class(index)
    if index.zero?
      "text-lg font-bold"
    else
      "flex-col p-spacing"
    end
  end
end
