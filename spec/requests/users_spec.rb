require 'rails_helper'
 
 RSpec.describe "Users", type: :request do
   describe "GET /signup" do
     it "returns http success" do
       get signup_path
       expect(response).to have_http_status(:ok)
     end

     it 'NEXT公務員が含まれること' do
        get signup_path
        expect(response.body).to include 'NEXT公務員'
     end
   end

   describe 'POST /users #create' do
    context '有効な値の場合' do
      let(:user) { FactoryBot.create(:user) } #DB登録される
      let(:user_params) { { user: {
                      name: 'Example User',
                      email: 'user@example.com',
                      password: 'password',
                      password_confirmation: 'password' } } }

      before do
        ActionMailer::Base.deliveries.clear
      end

      it '登録されること' do
        expect {
          post users_path, params: user_params
        }.to change(User, :count).by 1
      end

      it 'メールが1件存在すること' do
        post users_path, params: user_params
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end

      it '登録時点ではactivateされていないこと' do
        post users_path, params: user_params
        expect(User.last.activated?).to be_falsey
      end

      it 'rootページにリダイレクトされること' do
        post users_path, params: user_params
        expect(response).to redirect_to root_path
      end
    end

      it '無効な値だと登録されないこと' do
        expect {
          post users_path, params: {
            user: {
              name: '',
              email: 'user@invlid',
              password: 'foo',
              password_confirmation: 'bar'
            }
          }
        }.to_not change(User, :count)
      end
   end

   describe 'PATCH /users' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:admin_user) { create(:user, :admin) }

    context '無効な値の場合' do
      it '更新できないこと' do
        patch user_path(user), params: { user: { name: '',
                                         email: 'foo@invlid',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
        user.reload
        expect(user.name).to_not eq ''
        expect(user.email).to_not eq ''
        expect(user.password).to_not eq 'foo'
        expect(user.password_confirmation).to_not eq 'bar'
      end
    end

    it 'admin属性は更新できないこと' do
      # userはこの後adminユーザになるので違うユーザにしておく
      login_for_request(user)
      expect(user.admin).to be_falsey
      patch user_path(user), params: { user: { password: user.password,
                                               password_confirmation: user.password,
                                               admin: true } }
      expect(user.reload.admin).to be_falsey
    end
  end
 end

 