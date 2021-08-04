require "./sendgrid_structs"
require "http"
require "base64"

module Sendgrid
  class Client
    def initialize(@api_key : String, address : String = "https://api.sendgrid.com/v3/mail/send")
      @uri = URI.parse(address)
      @logger = ::Log.for(Sendgrid)
    end

    def message(
      to : String | Hash(String, String) | Array(String), # email, name => email, or a list of emails
      from : String | NamedTuple(name: String, email: String),
      subject : String,
      content : String,
      cc : String | Hash(String, String) | Array(String)? = nil,
      bcc : String | Hash(String, String) | Array(String)? = nil,
      attachment_content : String? = nil,
      attachment_type : String? = nil,
      attachment_name : String? = nil,
      content_type : String = "text/plain"
    )
      to_addresses = construct_to(to)

      cc_addresses = construct_to(cc) if cc
      bcc_addresses = construct_to(bcc) if bcc

      from_address = construct_from(from)
      personalizations = [Personalization.new(to: to_addresses, cc: cc_addresses, bcc: bcc_addresses)]

      Message.new(personalizations: personalizations, from: from_address, subject: subject, content: [Content.new(type: content_type, value: content)],
        attachments: (attachment_content ? [Attachment.new(content: Base64.strict_encode(attachment_content), type: attachment_type, filename: attachment_name)] : nil)
      )
    end

    def message(
      to : String | Hash(String, String) | Array(String), # email, name => email, or a list of emails
      from : String | NamedTuple(name: String, email: String),
      subject : String,
      template_id : String,
      template_data : Hash(String, String)
    )
      to_addresses = construct_to(to)
      from_address = construct_from(from)
      personalizations = [Personalization.new(to: to_addresses, dynamic_template_data: template_data)]

      Message.new(personalizations: personalizations, from: from_address, subject: subject, template_id: template_id)
    end

    def send(message : Message)
      HTTP::Client.post(@uri, request_headers, message.to_json)
    end

    def construct_to(to : String | Hash(String, String) | Array(String)) : Array(Address)
      if to.is_a?(String)
        return [Address.new(email: to)]
      elsif to.is_a?(Hash(String, String))
        return to.map { |name, email| Address.new(name: name, email: email) }
      else
        return to.map { |email| Address.new(email: email) }
      end
    end

    def construct_from(from : String | NamedTuple(name: String, email: String)) : Address
      if from.is_a?(String)
        return Address.new(email: from)
      else
        return Address.new(name: from[:name], email: from[:email])
      end
    end

    private def request_headers
      HTTP::Headers{
        "Authorization" => "Bearer #{@api_key}",
        "Content-Type"  => "application/json",
      }
    end
  end
end
