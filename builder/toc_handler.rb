# Copyright (c) 2010 ThoughtWorks Inc., licensed under MIT license 

class TocHandler < ElementHandler
  def initialize(html, root)
    super(html, root)
  end
  
  def setCurrentEntryName(entryName)
    @current_entry_name = entryName
  end
  
  def handle_index(element)
    @html.element('ul', 'class' => 'toc') do
      apply(element)
    end
  end
  
  def handle_entry(element)
    @html.element('li') do
      ref = element.attributes['reference']
      actual_file = File.join(File.dirname(__FILE__), '..', 'topics', "#{ref}.xml")
      if File.exist?(actual_file)
        root = REXML::Document.new(File.new(actual_file)).root
        cssClass = ref == @current_entry_name ? 'current' : ''
        @html.element('a', {'href' => "#{ref}.html", 'class' => cssClass}){@html.text(root.attributes['title'])}
      else
        title = ref.gsub(/_/, ' ')
        title = title[0..0].upcase + title[1..-1]
        @html.element('a', 'href' => "under_construction.html"){@html.text(title)}
      end
      if element.elements.size > 0
        @html.element('ul') do
          apply(element)
        end
      else
        apply(element)
      end
    end
  end
end