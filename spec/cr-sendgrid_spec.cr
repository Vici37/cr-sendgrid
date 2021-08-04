require "./spec_helper"

describe Sendgrid do
  client = Sendgrid::Client.new("onlyTheBestApiKey")

  Spec.after_each do
    WebMock.reset
  end

  it "sends emails" do
    WebMock.stub(:post, "https://api.sendgrid.com/v3/mail/send")
      .with(headers: {"Authorization" => "Bearer onlyTheBestApiKey"})
      .to_return(status: 202, headers: {"X-Message-Id" => "super-message-id"}, body: "it worked!")

    # client = Sendgrid::Client.new("onlyTheBestApiKey")

    message = client.message(
      to: {"Testing Tyler" => "test.tyler@example.com"},
      from: {name: "Robo Roboto", email: "robo.roboboto@example.com"},
      subject: "Best Test Message",
      content: "Did it work?"
    )
    resp = client.send(message)
    resp.status_code.should eq 202
    resp.body.should eq "it worked!"
  end

  it "sends attachements" do
    WebMock.stub(:post, "https://api.sendgrid.com/v3/mail/send")
      .with(headers: {"Authorization" => "Bearer onlyTheBestApiKey"})
      .to_return(status: 202, headers: {"X-Message-Id" => "super-message-id"}, body: "it worked!")

    pic = ""
    File.open("./spec/mandlebrot_python.png") do |file|
      pic = file.gets_to_end
    end

    message = client.message(
      to: {"Testing Tyler" => "testing.tyler@example.com"},
      from: {name: "Robo Roboto", email: "robo.roboto@example.com"},
      subject: "Best Test Message",
      content: "Did it work with a picture?",
      attachment_content: pic,
      attachment_type: "image/png",
      attachment_name: "Mandlebrot.png"
    )

    resp = client.send(message)

    resp.status_code.should eq 202
    resp.body.should eq "it worked!"
  end

  it "sends with templates" do
    WebMock.stub(:post, "https://api.sendgrid.com/v3/mail/send")
      .with(headers: {"Authorization" => "Bearer onlyTheBestApiKey"})
      .to_return(status: 202, headers: {"X-Message-Id" => "super-message-id"}, body: "it worked!")

    message = client.message(
      to: {"Testing Tyler" => "troy@sornson.io"},
      from: {name: "Robo Roboto", email: "bot@mailer.sornson.io"},
      subject: "Best Test Message",
      template_id: "d-eae5d8e58f3043f5af37f128068a43db",
      template_data: {"name" => "Troy", "link" => "Wontwork"}
    )

    resp = client.send(message)

    resp.status_code.should eq 202
    resp.body.should eq "it worked!"
  end
end
