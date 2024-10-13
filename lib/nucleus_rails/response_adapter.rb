module NucleusRails
  class ResponseAdapter
    attr_reader :controller

    FILE_TYPES = %i[csv pdf png jpeg jpg gif bmp svg mp4 mp3 wav webm ogg zip tar].freeze

    # `controller` is an instance of either:
    # - ActionController::Base
    # - ActionController::API
    def initialize(controller)
      @controller = controller
    end

    # `entity` is an instance of `NucleusCore::View::Response`.
    # Which contains the following attributes:
    # - `content`: The body or content of the response.
    # - `format`: The data type of the response.
    # - `headers`: A hash representing HTTP headers for the response.
    # - `status`: The HTTP status code (e.g., 200, 404).
    # - `location`: The location header for redirection responses.
    # - `filename`: The name for any file downloads (optional).
    # - `type`: The MIME type of the response (e.g., "application/json").
    # - `disposition`: Content disposition (e.g., "inline" or "attachment").
    # rubocop:disable Rails/OutputSafety, ;
    def call(entity)
      init_render_context(entity)

      requested_format = entity.format&.to_sym

      case requested_format
      when :json, :xml, :text, :atom, :js, :html
        prepared_format = requested_format == :text ? :plain : requested_format
        prepared_content = requested_format == :html ? entity.content.html_safe : entity.content
        controller.render(prepared_format => prepared_content, **render_attributes(entity))
      when *FILE_TYPES
        controller.send_data(entity.content, render_attributes(entity))
      else
        controller.head(:no_content, render_attributes(entity))
      end
    end
    # rubocop:enable Rails/OutputSafety:

    private

    def init_render_context(entity)
      render_headers(entity.headers)
    end

    def render_headers(headers={})
      (headers || {}).each do |k, value|
        formatted_key = k.gsub(/\s *|_/, "-")

        controller.response.set_header(formatted_key, value)
      end
    end

    def render_attributes(entity)
      entity.to_h.except!(:format, :content, :type)
    end
  end
end
