require "active_support"
require "action_controller/railtie"
require "nucleus_core"

module NucleusRails::Responder
  extend ActiveSupport::Concern
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  include NucleusCore::Responder

  included do
    before_action do |controller|
      init_responder(
        response_adapter: controller,
        request_format: controller.request&.format
      )
    end

    rescue_from Exception, with: :handle_exception
  end

  delegate :set_header, to: :response

  # entity: <Nucleus::ResponseAdapter>
  def render_json(entity)
    render(json: entity.content, **entity_render_attributes(entity))
  end

  def render_xml(entity)
    render(xml: entity.content, **entity_render_attributes(entity))
  end

  def render_text(entity)
    render(plain: entity.content, **entity_render_attributes(entity))
  end

  def render_pdf(entity)
    send_data(entity.content, entity_render_attributes(entity))
  end

  def render_csv(entity)
    send_data(entity.content, entity_render_attributes(entity))
  end

  def render_nothing(entity)
    head(:no_content, entity_render_attributes(entity))
  end

  private

  def entity_render_attributes(entity)
    entity.to_h.except(:content)
  end
end
