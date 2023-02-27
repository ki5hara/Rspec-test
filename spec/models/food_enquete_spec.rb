require 'rails_helper'

RSpec.describe FoodEnquete, type: :model do
  
  describe '正常系の機能' do
    context '回答する' do
      it '正しく登録できること 料理:焼きそば food_id:2,
                    満足度:良い score: 3,
                    希望するプレゼント: ビール飲み放題 present_id:1' do

            # # テストデータを作成
            # enquete = FoodEnquete.new(
            #   name: '田中 太郎',
            #   mail: 'taro.tanaka@example.com',
            #   age: 25,
            #   food_id: 2,
            #   score: 3,
            #   request: 'おいしかったです。',
            #   present_id: 1
            # )

        enquete = FactoryBot.build(:food_enquete_tanaka)
        # [Point.3-3-2]「バリデーションが正常に通ること(バリデーションエラーが無いこと)」を検証します
        # テストデータ（enquete）が有効（be_valid）であるかどうか(to)のテスト
        expect(enquete).to be_valid

        # [Point.3-3-3]テストデータを保存します。
        enquete.save

        # 保存したデータを取得します。
        answered_enquete = FoodEnquete.find(1);

        # 作成したデータを同一か検証します。
        expect(answered_enquete.name).to eq('田中 太郎')
        expect(answered_enquete.mail).to eq('taro.tanaka@example.com')
        expect(answered_enquete.age).to eq(25)
        expect(answered_enquete.food_id).to eq(2)
        expect(answered_enquete.score).to eq(3)
        expect(answered_enquete.request).to eq('おいしかったです。')
        expect(answered_enquete.present_id).to eq(1)
      end
    end
  end

  # describe '入力項目の有無' do
  #   let(:new_enquete) { FoodEnquete.new }
  #   context '必須入力であること' do
  #     # itを複数書くことができる
  #     it 'お名前が必須であること' do
  #       # new_enquete = FoodEnquete.new
  #       # バリデーションエラーが発生することを検証します。
  #       expect(new_enquete).not_to be_valid
  #       # 必須入力のメッセージが含まれることを検証します。
  #       expect(new_enquete.errors[:name]).to include(I18n.t('errors.messages.blank'))
  #     end

  #     it 'メールアドレスが必須であること' do
  #       # new_enquete = FoodEnquete.new
  #       expect(new_enquete).not_to be_valid
  #       expect(new_enquete.errors[:mail]).to include(I18n.t('errors.messages.blank'))
  #     end

  #     it '登録できないこと' do
  #       # new_enquete = FoodEnquete.new
  #       # 保存に失敗することを検証します。
  #       expect(new_enquete.save).to be_falsey
  #     end
  #   end

  #   context '任意入力であること' do
  #     it 'ご意見・ご要望が任意であること' do
  #       # new_enquete = FoodEnquete.new
  #       expect(new_enquete).not_to be_valid
  #       #  必須入力のメッセージが含まれないことを検証します。
  #       expect(new_enquete.errors[:request]).not_to include(I18n.t('errors.messages.blank'))
  #     end
  #   end
  # end

  #プライベートメソッドadult?の年齢判定のテストを実行する
  describe  '#adult' do
    it '20歳未満は成人ではないこと'do
    foodEnquete = FoodEnquete.new
    #[Point.3-5-1] 未成年になることを検証します
    expect(foodEnquete.send(:adult?, 19)).to be_falsey
  end

  it '20歳以上は成人であること' do
    foodEnquete = FoodEnquete.new
    # 成人になることを検証します。
    expect(foodEnquete.send(:adult?, 20)).to be_truthy
  end
end

  describe 'アンケート回答時の条件' do
    context '年齢を確認すること'do
      it '未成年はビール飲み放題を選択できないこと' do
        # 未成年のテストデータを作成します。
        # enqute_sato = FoodEnquete.new(
        #   name: '佐藤 仁美',
        #   mail: 'hitomi.sato@example.com',
        #   age: 19,
        #   food_id: 2,
        #   score: 3,
        #   request: 'おいしかったです。',
        #   present_id: 1   # ビール飲み放題
        # )

        enquete_sato = FactoryBot.build(:food_enquete_sato)


        expect(enquete_sato).not_to be_valid
        # 成人のみ選択できる旨のメッセージが含まれることを検証します。
        expect(enquete_sato.errors[:present_id]).to include(I18n.t('activerecord.errors.models.food_enquete.attributes.present_id.cannot_present_to_minor'))
      end

      it '成人はビール飲み放題を選択できないこと' do
        # 未成年のテストデータを作成します。
        # enquete_sato = FoodEnquete.new(
        #   name: '佐藤 仁美',
        #   mail: 'hitomi.sato@example.com',
        #   age: 20,
        #   food_id: 2,
        #   score: 3,
        #   request: 'おいしかったです。',
        #   present_id: 1   # ビール飲み放題
        # )

        enquete_sato = FactoryBot.build(:food_enquete_sato, age: 20)


        # バリデーションが正常に通ること（バリデーションエラーがないこと）を検証します。
        expect(enquete_sato).to be_valid
      end
    end

    # 1. 同一のメールアドレスで複数の回答ができないことを確認するテストを実行する

    context 'メールアドレスを確認すること' do
      # 1. 「田中 太郎」のテストデータを前処理で共通化する
      before do
        FactoryBot.create(:food_enquete_tanaka)
      end

      # it '同じメールアドレスで再び回答できないこと' do
        # 一つ目のテストデータを作成します。
        # enquete_tanaka = FoodEnquete.new(
        #   name: '田中 太郎',
        #   mail: 'taro.tanaka@example.com',
        #   age: 25,
        #   food_id: 2,
        #   score: 3,
        #   request: 'おいしかったです。',
        #   present_id: 1
        # )
        # enquete_tanaka.save
        # FactoryBot.create(:food_enquete_tanaka)


        # 二つ目のテストデータを作成します。
        # re_enquete_tanaka = FoodEnquete.new(
        #     name: '田中 太郎',
        #     mail: 'taro.tanaka@example.com',
        #     age: 25,
        #     food_id: 0,
        #     score: 1,
        #     request: 'スープがぬるかった',
        #     present_id: 0
        # )
        # expect(re_enquete_tanaka).not_to be_valid

      #   re_enquete_tanaka = FactoryBot.build(:food_enquete_tanaka, food_id: 0, score: 1, present_id: 0, request: "スープがぬるかった")

      #   # メールアドレスが既に存在するメッセージが含まれることを検証します。
      #   expect(re_enquete_tanaka).not_to be_valid
      #   expect(re_enquete_tanaka.errors[:mail]).to include(I18n.t('errors.messages.taken'))
      #   expect(re_enquete_tanaka.save).to be_falsey
      #   expect(FoodEnquete.all.size).to eq 1
      # end

      # 5-1-3 再び「田中 太郎」のテストデータでアンケートに回答します。
      it '同じメールアドレスで再び回答できること' do
        re_enquete_tanaka = FactoryBot.build(:food_enquete_tanaka, food_id: 0, score: 1, present_id: 0, request: "スープがぬるかった")
        expect(re_enquete_tanaka).to be_valid
        expect(re_enquete_tanaka.save).to be_truthy
        expect(FoodEnquete.all.size).to eq 2
      end

      # 2. 異なるメールアドレスで複数の回答ができることを確認するテストを実行する
        it '異なるメールアドレスで回答できること'do
        # enquete_tanaka = FoodEnquete.new(
        #   name: '田中 太郎',
        #   mail: 'taro.tanaka@example.com',
        #   age: 25,
        #   food_id: 2,
        #   score: 3,
        #   request: 'おいしかったです。',
        #   present_id: 1
        # )
        # enquete_tanaka.save

        # FactoryBot.create(:food_enquete_tanaka)


        # enquete_yamada = FoodEnquete.new(
        #   name: '山田 次郎',
        #   mail: 'jiro.yamada@example.com',
        #   age: 22,
        #   food_id: 1,
        #   score: 2,
        #   request: '',
        #   present_id: 0
        # )

        enquete_yamada = FactoryBot.build(:food_enquete_yamada)


        expect(enquete_yamada).to be_valid
        enquete_yamada.save
        # 問題なく登録できます。
        expect(FoodEnquete.all.size).to eq 2
      end
    end
  end

  describe 'メールアドレス'do
    context '不正な形式のメールアドレスの場合' do
      it 'エラーになること' do
        new_enquete = FoodEnquete.new
        # 不正な形式のメールアドレスを入力します。
        new_enquete.mail = 'taro.tanaka'
        expect(new_enquete).not_to be_valid
        # 不正な形式なのメッセージが含まれることを検証します。
        expect(new_enquete.errors[:mail]).to include(I18n.t('errors.messages.invalid'))
      end
    end
  end

  describe '共通バリデーション' do
    it_behaves_like '入力項目の有無'
    it_behaves_like 'メールアドレスの形式'
  end

  describe '共通メソッド' do
    # 共通化するテストケースを定義します。
    it_behaves_like '価格の表示'
    it_behaves_like '満足度の表示'
  end



end
