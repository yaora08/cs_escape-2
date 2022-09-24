require 'rails_helper'
 
RSpec.describe UserMailer, type: :mailer do
  describe 'account_activation' do
    let(:user) { FactoryBot.create(:user) }
    let(:mail) { UserMailer.account_activation(user) }
 
    before do
      user.activation_token = User.new_token
    end
 
    it '"Account activation"というタイトルで送信されること' do
      expect(mail.subject).to eq('Account activation')
    end
 
    it '送信先が"to@example.org"であること' do
      expect(mail.to).to eq([user.email])
    end
 
    it '送信元が"from@example.com"であること' do
      expect(mail.from).to eq(['noreply@example.com'])
    end
 
    it 'メール本文にユーザ名が表示されていること' do
      expect(mail.text_part.body.to_s).to match(user.name)
    end
 
    it 'メール本文にユーザのactivation_tokenが表示されていること' do
      expect(mail.text_part.body.to_s).to match(user.activation_token)
    end

    it 'メール本文にユーザのemailが表示されていること' do
      expect(mail.text_part.body.to_s).to match(CGI.escape(user.email))
    end
  end
end

# RSpec.describe UserMailer, type: :mailer do
#   describe "account_activation" do
#     let(:mail) { UserMailer.account_activation(@user) }

#     before do
#       @user = FactoryBot.create(:user)
#     end


#     it "renders the headers" do
#       expect(mail.subject).to eq("Account activation")
#       expect(mail.to).to eq([@user.email])
#       expect(mail.from).to eq(["noreply@example.com"])
#     end

#     it "renders the body" do
#       expect(mail.text_part.body.to_s).to match(@user.name)
#       expect(mail.text_part.body.to_s).to match("NEXT公務員へようこそ！ リンクをクリックして認証を完了させてください。")
#     end

#     it 'メール本文にユーザのactivation_tokenが表示されていること' do
#       expect(mail.text_part.body.to_s).to match(@user.activation_token)
#     end
#   end

#   #--------password_reset-------

#   # describe "password_reset" do
#   #   let(:mail) { UserMailer.password_reset }

#   #   it "renders the headers" do
#   #     expect(mail.subject).to eq("Password reset")
#   #     expect(mail.to).to eq(["to@example.org"])
#   #     expect(mail.from).to eq(["from@example.com"])
#   #   end

#   #   it "renders the body" do
#   #     expect(mail.body.encoded).to match("Hi")
#   #   end
#   # end

# end
