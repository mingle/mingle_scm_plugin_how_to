# Copyright (c) 2010 ThoughtWorks Inc., licensed under MIT license 

class TopicMaker

	attr_accessor :css_styles, :page_header, :page_footer, :is_xhtml

	def initialize(source_file, toc_source_file, output_directory)
		output_file = File.new(File.join(output_directory, (File.basename(source_file, '.xml') + '.html')), 'w')
		@html = HtmlRenderer.new(output_file)
		@root = REXML::Document.new(File.new(source_file)).root
		@body_handler = TopicHandler.new(@html, @root)
		@toc_root = REXML::Document.new(File.new(toc_source_file)).root
		@toc_handler = TocHandler.new(@html, @toc_root)
		@current_page_name = File.basename(source_file, '.xml')
	end
		
	def title_text
		(@root.elements['//chapter'] || @root.elements['//topic'] || @root.elements['//section'] || @root.elements['//subsection']).attributes['title']
	end	
	
	def run
		render_page
		@html.close
	end
	
	def render_page		
		@html.element('html', html_attrs) do
		  render_head
			@html.element('body') do
        # @html.element('div', {'id' => 'doc3', 'class' => 'yui-t3'}) do
			    
			    @html.element('div', {'id' => 'hd'}) do
			      @html.element('h1') do
			        @html.text('Help')
			      end
		      end
			    
          # @html.element('div', {'id' => 'bd'}) do
			      @html.element('div', {'id' => 'main-container'}) do
  			      @html.element('div', {'id' => 'main'}) do
                # render_under_construction
  			        
  				      @body_handler.render
  				    end
  				  end
            # @html.element('div', {'id' => 'nav', 'class' => 'yui-b'}) do
				    @html.element('div', {'id' => 'nav'}) do
				      @toc_handler.setCurrentEntryName(@current_page_name)
				      @toc_handler.render
				    end
          # end
				  
				  @html.element('div', {'id' => 'ft', 'class' => 'footer'}) do
			      @html.text('&copy; ThoughtWorks Inc., 2010')
				  end
			  
        # end
			end
    end
	end
	
	def render_toc
	  @html.element('div', {'class' => 'toc'}) do
  		@toc_root = REXML::Document.new(File.new(source_file)).root
	  end
	end
	
	def html_attrs
		if @is_xhtml
			return { 'xmlns' => 'http://www.w3.org/1999/xhtml',
					'xml:lang' => "en", 
					'lang' => "en"}
			else return ''
		end
	end

	def render_head
		html_head_title title_text
	end
	
	def html_head_title title
		@html.element 'head' do
		@html.element('meta', 'http-equiv' => 'Content-Type', 'content' => 'text/html; charset=UTF-8'){}
		@html.element('title') {@html.text title}
		@html.element('link', 'href' => 'resources/stylesheets/mingle_help.css', 'media' => 'screen',
		  'rel' => 'Stylesheet', 'type' => 'text/css'){}
		@html.element('script', 'src' => 'resources/javascript/prototype.js', 'type' => 'text/javascript'){}
		@html.element('script', 'src' => 'resources/javascript/mingle_help.js', 'type' => 'text/javascript'){}
		end
	end

	def up_to_date input, output
		return false if not File.exists? output
		return File.stat(output).mtime > File.stat(input).mtime
	end

  def render_under_construction
    @html.element('div', {'class' => 'under-construction-container'}) do
      @html.element('div', {'class' => 'under-construction-content'}) do
        @html.element('p', {'class' => 'strong'}) do
          @html.text 'We\'re not quite finished yet!'
        end
        
        @html.element('p') do
          @html.text 'The help text provided for this Early Access release is provisional.'
        end
      
        @html.element('p') do
          @html.text 'Please bear with us while we work to finalise it for the full release.'
        end
      end
    end
  end

end