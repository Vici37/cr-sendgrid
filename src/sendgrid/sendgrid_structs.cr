require "json"

module Sendgrid
  # Objects defined from the API interface defined here: https://docs.sendgrid.com/api-reference/mail-send/mail-send

  record Message,
    personalizations : Array(Personalization),
    from : Address,
    subject : String,
    content : Array(Content),
    reply_to : Address? = nil,
    template_id : String? = nil,
    headers : Hash(String, String)? = nil,
    categories : Array(String)? = nil,
    custom_args : Hash(String, String)? = nil,
    send_at : Int64? = nil,
    batch_id : String? = nil,
    asm : AdvancedSuppressionManagement? = nil,
    ip_pool_name : String? = nil,
    attachments : Array(Attachment)? = nil,
    tracking_settings : TrackingSettings? = nil do
    include JSON::Serializable
  end

  record Address,
    email : String,
    name : String? = nil do
    include JSON::Serializable
  end

  record Content,
    type : String,
    value : String do
    include JSON::Serializable
  end

  record Personalization,
    from : Address? = nil,
    to : Array(Address)? = nil,
    cc : Array(Address)? = nil,
    bcc : Array(Address)? = nil,
    subject : String? = nil,
    headers : Hash(String, String)? = nil,
    substitutions : Hash(String, String)? = nil,
    dynamic_template_data : Hash(String, String)? = nil,
    custom_args : Hash(String, String)? = nil,
    send_at : Int64? = nil do
    include JSON::Serializable
  end

  record Attachment,
    content : String,
    type : String,
    filename : String? = nil,
    disposition : String? = nil,
    content_id : String? = nil do
    include JSON::Serializable
  end

  record AdvancedSuppressionManagement,
    group_id : Int64,
    groups_to_display : Array(Int64)? = nil do
    include JSON::Serializable
  end

  record MailSetting,
    bypass_list_management : EnableSetting? = nil,
    bypass_spam_management : EnableSetting? = nil,
    bypass_bounce_management : EnableSetting? = nil,
    bypass_unsubscribe_management : EnableSetting? = nil,
    footer : Footer? = nil,
    sandbox_mode : EnableSetting? = nil do
    include JSON::Serializable
  end

  record EnableSetting,
    enable : Bool do
    JSON::Serializable
  end

  record Footer,
    enable : Bool,
    text : String? = nil,
    html : String? = nil do
    include JSON::Serializable
  end

  record TrackingSettings,
    click_tracking : ClickTracking? = nil,
    open_tracking : OpenTracking? = nil,
    subscription_tracking : SubscriptionTracking? = nil,
    ganalytics : GAnalytics? = nil do
    include JSON::Serializable
  end

  record ClickTracking,
    enable : Bool,
    enable_text : String? = nil do
    include JSON::Serializable
  end

  record OpenTracking,
    enable : Bool,
    substitution_tag : String? = nil do
    include JSON::Serializable
  end

  record SubscriptionTracking,
    enable : Bool,
    text : String? = nil,
    html : String? = nil,
    substitution_tag : String? = nil do
    include JSON::Serializable
  end

  record GAnalytics,
    enable : Bool,
    utm_source : String? = nil,
    utm_medium : String? = nil,
    utm_term : String? = nil,
    utm_content : String? = nil,
    utm_campaign : String? = nil do
    include JSON::Serializable
  end
end
