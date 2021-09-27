require 'rails_helper'
require 'net/http'

RSpec.describe '#search' do
  describe 'GET /api/v1/subjects?keyword=◯◯◯' do
    #リクエストURL
    let(:request_url) {
      'http://localhost:3000/api/v1/subjects?keyword=' + key + '&teacher_name=' + name
    }
    #json形式のレスポンス
    let(:res) { JSON.parse(Net::HTTP.get(URI.parse(request_url))) }

    #文字列をエンコード
    let(:key) { URI.encode_www_form_component(keyword) }
    let(:name) { URI.encode_www_form_component(teacher_name) }

    #検索ワードの初期値
    let(:keyword) { '' }
    let(:teacher_name) { '' }

    before { get request_url }

    shared_examples 'HTTP Response Status Code' do
      it '「200 OK」を返すこと' do
        expect(response).to have_http_status(200)
      end
    end

    shared_examples 'No Content' do
      it '該当するデータがないと返すこと' do
        expect(response.body).to eq("該当する科目はありません")
      end
    end

    #searchアクションのケース1のテスト
    context '検索キーワードに該当しないパターン' do
      context 'keyword(科目検索)、teacher_name(教員名検索)どちらも入力されていて共に該当がない場合' do
        let(:keyword) { '暗殺教室の授業' }
        let(:teacher_name) { '殺せんせー' }

        it_behaves_like 'No Content'
        it_behaves_like 'HTTP Response Status Code'
      end

      context '片方が該当なし、もう片方が未入力の場合' do
        let(:teacher_name) { '殺せんせー' } #keywordには初期値のnilが入る

        it_behaves_like 'No Content'
        it_behaves_like 'HTTP Response Status Code'
      end
    end

    #searchアクションのケース2のテスト
    context 'keywordのみ入力され該当があるパターン(科目名検索)' do
      context '該当するデータが1個の場合' do
        let(:keyword) { 'グレート' }

        it '1個のデータを返すこと' do
          expect(res['subjects'][0]['title']).to eq("グレートなティーチャーによる教育論")
        end

        #要件5　　Responseにおいて科目ごとに授業は開講年月日(date)において昇順にソートされている必要がある
        it 'Lectureがdateの昇順でソートされていること' do
          lectures = res['subjects'][0]['lectures'].map {|l| l['date']}
          expect(lectures).to eq(["2021-04-12", "2021-04-19"])
        end

        it_behaves_like 'HTTP Response Status Code'
      end

      context '該当するデータが2個の場合' do
        let(:keyword) { '講座' }

        it '2個のデータを返すこと' do
          expect(res['subjects'][0]['title']).to eq("悪霊・鬼の倒し方実践講座")
          expect(res['subjects'][1]['title']).to eq("必勝！実践空手講座")

        end

        it 'Lectureがdateの昇順でソートされていること' do
          lectures = res['subjects'][0]['lectures'].map {|l| l['date']}
          expect(lectures).to eq(["2021-04-16", "2021-04-23"])
        end

        it_behaves_like 'HTTP Response Status Code'
      end
    end

    #searchアクションのケース3のテスト
    context 'teacher_nameのみ入力され該当があるパターン(教員名検索)' do
      context '該当するデータが1個の場合' do
        let(:teacher_name) { '鬼塚' }

        it '1個のデータを返すこと' do
          expect(res['subjects'][0]['teacher']['name']).to eq("鬼塚先生")
        end

        it 'Lectureがdateの昇順でソートされていること' do
          lectures = res['subjects'][0]['lectures'].map {|l| l['date']}
          expect(lectures).to eq(["2021-04-12", "2021-04-19"])
        end

        it_behaves_like 'HTTP Response Status Code'
      end

      context '該当するデータが2個の場合' do
        let(:teacher_name) { '先生' }

        #要件7　　seeds.rbによって教師が2人いる状況であること
        it 'teacher(教師)が2人存在すること' do
          teacher_name_array = res['subjects'].map do |data|
            data['teacher']['name']
          end
          expect(teacher_name_array.uniq.length).to eq(2)
        end

        it '2個のデータを返すこと' do
          expect(res['subjects'][0]['teacher']['name']).to eq("鬼塚先生")
          expect(res['subjects'][1]['teacher']['name']).to eq("鵺野先生")
        end

        it 'Lectureがdateの昇順でソートされていること' do
          lectures = res['subjects'][0]['lectures'].map {|l| l['date']}
          expect(lectures).to eq(["2021-04-12", "2021-04-19"])
        end

        it_behaves_like 'HTTP Response Status Code'
      end
    end

    #searchアクションのケース4のテスト
    context 'keywordとteacher_nameどちらも入力されていて共に該当があるパターン(科目名と教員名のAND検索)' do
      context '両方に該当しデータが重複する(AND検索が成り立つ)場合' do
        let(:keyword) { '講座' }
        let(:teacher_name) { '鬼' }

        it '該当するデータを返すこと' do
          expect(res['subjects'][0]['title']).to eq('必勝！実践空手講座')
        end

        it 'Lectureがdateの昇順でソートされていること' do
          lectures = res['subjects'][0]['lectures'].map {|l| l['date']}
          expect(lectures).to eq(['2021-04-21', '2021-05-19'])
        end

        it_behaves_like 'HTTP Response Status Code'
      end

      context '両方に該当するが重複するデータがない(AND検索が成り立たない)場合' do
        let(:keyword) { '鬼' }
        let(:teacher_name) { '鬼' }

        it_behaves_like 'No Content'
        it_behaves_like 'HTTP Response Status Code'
      end
    end
  end


  #エラー関係のテスト
  describe 'GET /api/v1/subjects' do
    context 'リクエストURLが間違っているパターン' do
      before { get '/api/v1/subjects' }

      it 'エラー文を表示すること' do
        expect(response.body).to include("リクエストが間違っています")
      end

      it 'ステータスコードが404であること' do
        expect(response).to have_http_status(404)
      end
    end
  end
end