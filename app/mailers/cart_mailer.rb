class CartMailer < ApplicationMailer
  def dispatch_invoice(cart)
    if cart.invoice.exists?
      uri = URI.parse cart.invoice.url
      response = Net::HTTP.start(uri.host, uri.port) do |http|
        http.get uri.path
      end
      attachments["Invocie-#{cart.reference_number}-#{cart.created_at.strftime("%F")}.pdf"] = response.body
    end

    mail(to: cart.customer.email, subject: "Life Elixir Invoice ##{cart.reference_number}")
  end
end
