require 'rails_helper'

RSpec.describe "FoodEnquetes", type: :request do
  
  describe '正常' do
    context 'アンケートに回答する' do
      it '解答できること' do
        # アンケートページにアクセスします。
        get '/food_enquetes/new'
        # 正常に応答することを確認します。
        expect(response).to have_http_status(200)

        # 正常な入力値を送信します。
        post "/food_enquetes", params: { food_enquete: FactoryBot.attributes_for(:food_enquete_tanaka) }

        # リダイレクト先に移動します。
        follow_redirect!
        # 送信完了のメッセージが含まれることを検証します。
        # expect(response.body).to include "お食事に関するアンケートを送信しました"
        expect(response.body).to include "ご回答ありがとうございました"



      end
    end
  end


  describe '異常' do
    context 'アンケートに回答する' do
      it 'エラーメッセージを表示されること' do
        get '/food_enquetes/new'
        expect(response).to have_http_status(200)

        # 異常な入力値を送信します。
        post '/food_enquetes' , params: { food_enquete: {name: ''}}
        # 送信完了のメッセージが含まれないことを検証します。
        # expect(response.body).not_to include 'お食事に関するアンケートを送信しました'
        expect(response.body).not_to include "ご回答ありがとうございました"

      end
    end
  end




end
