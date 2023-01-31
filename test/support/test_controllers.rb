require "securerandom"
require "ostruct"

class SimpleView < Nucleus::View
  def initialize(attrs={})
    super(attrs)
  end

  def json_response
    Nucleus::JsonResponse.new
  end

  def xml_response
    Nucleus::XmlResponse.new
  end

  def pdf_response
    Nucleus::PdfResponse.new
  end

  def csv_response
    Nucleus::CsvResponse.new
  end

  def text_response
    Nucleus::TextResponse.new
  end
end

class TestController
  include Nucleus::Responder

  attr_accessor :request, :params

  def initialize(request_format: :json, params: { total: 5 })
    @format = request_format
    @params = params
  end

  def index
    handle_response do
      policy.enforce!(:can_write?)

      context, _process = SimpleWorkflow.call(context: params)

      return SimpleView.new(total: context.total) if context.success?

      return context
    end
  end

  def show
    handle_response do
      policy.enforce!(:can_read?)

      context = TestOperation.call(params)

      return SimpleView.new(total: context.total) if context.success?

      return context
    end
  end

  private

  def policy
    TestPolicy.new(current_user)
  end

  def current_user
    OpenStruct.new(id: SecureRandom.uuid)
  end
end
