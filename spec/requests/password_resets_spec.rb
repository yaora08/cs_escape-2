require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
    let(:user) { FactoryBot.create(:user)}

    before do
        ActionMailer::Base.deliveries.clear
    end


    describe '#new' do
        it 'password_reset[email]というname属性のinputタグが表示されること' do
            get new_password_reset_path
            expect(response.body).to include "name=\"password_reset[email]\""
        end
    end

    describe '#create' do
        it '無効なメールアドレスならflashが存在すること' do
            post password_resets_path, params: {password_reset: {email: ''}}
            expect(flash.empty?).to be_falsey
        end

        context '有効なメールアドレスの場合' do
            it 'reset_digestが変わっていること' do
                post password_resets_path, params: {password_reset: {email: user.email}}
                expect(user.reset_digest).to_not eq user.reload.reset_digest
            end

            it '送信メールが1件増えること' do
                expect {post password_resets_path, params: {password_reset: {email: user.email}}
                }.to change(ActionMailer::Base.deliveries, :count).by 1
            end

            it 'flashが存在すること' do
                post password_resets_path, params: { password_reset: { email: user.email } }
                expect(flash.empty?).to be_falsey
            end

            it 'rootにリダイレクトされること' do
                post password_resets_path, params: { password_reset: { email: user.email } }
                expect(response).to redirect_to root_path
            end

        end
    end

    describe '#edit' do
        before do
            post password_resets_path, params: { password_reset: { email: user.email } }
            @user = controller.instance_variable_get('@user')
        end

        it 'メールアドレスもトークンも有効なら、隠しフィールドにメールアドレスが表示されること' do
            get edit_password_reset_path(@user.reset_token, email: @user.email)
            expect(response.body).to include "<input type=\"hidden\" name=\"email\" id=\"email\" value=\"#{@user.email}\" />"
        end

        it 'メールアドレスが間違っていれば、rootにリダイレクトすること' do
            get edit_password_reset_path(@user.reset_token, email: '')
            expect(response).to redirect_to root_path
          end

          it '無効なユーザならrootにリダイレクトすること' do
            @user.toggle!(:activated)
            get edit_password_reset_path(@user.reset_token, email: @user.email)
            expect(response).to redirect_to root_path
          end

          it 'トークンが無効なら、rootにリダイレクトすること' do
            get edit_password_reset_path('wrong token', email: @user.email)
            expect(response).to redirect_to root_path
          end
    end

    describe '#update' do
        before do
          post password_resets_path, params: { password_reset: { email: user.email } }
          @user = controller.instance_variable_get('@user')
        end

        context '有効なパスワードの場合' do
            it 'ログイン状態になること' do
              patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                      user: { password: 'foobaz',
                                                                              password_confirmation: 'foobaz' } }
              expect(is_logged_in?).to be_truthy
            end

            it 'flashが存在すること' do
                patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                        user: { password: 'foobaz',
                                                                                password_confirmation: 'foobaz' } }
                expect(flash.empty?).to be_falsey
            end

            it 'ユーザの詳細ページにリダイレクトすること' do
                patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                        user: { password: 'foobaz',
                                                                                password_confirmation: 'foobaz' } }
                expect(response).to redirect_to @user
            end

            it 'パスワードと再入力が一致しなければ、エラーメッセージが表示されること' do
                patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                       user: { password: 'foobaz',
                                                                               password_confirmation: 'barquux' } }
                expect(response.body).to include "パスワード(確認)とパスワードの入力が一致しません"
            end

            it 'パスワードが空なら、エラーメッセージが表示されること' do
                patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                        user: { password: '',
                                                                                password_confirmation: '' } }
                expect(response.body).to include "パスワードを入力してください"
              end
        end


    end
end