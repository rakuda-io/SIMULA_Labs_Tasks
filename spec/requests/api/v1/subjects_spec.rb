require 'rails_helper'
require 'net/http'

RSpec.describe '#search' do
  describe 'GET /api/v1/subjects?keyword=◯◯◯' do
    before do
      @base_url = 'http://localhost:3000/api/v1/subjects?keyword='
    end

    #searchアクションのケース1のテスト
    context '検索キーワードになにも該当しないとき' do
      before do
        no_hit_url = '/api/v1/subjects?keyword=' + URI.encode_www_form_component('殺せんせー')
        get no_hit_url
      end

      it '検索結果がないと返すこと' do
        expect(response.body).to eq("該当する科目はありません")
      end

      it 'ステータスコードが200であること' do
        expect(response).to have_http_status(200)
      end
    end

    #searchアクションのケース2のテスト
    context '検索キーワードがSubject(科目)のみで該当するとき' do
      before do
        @one_hit_data_url = @base_url + URI.encode_www_form_component('悪霊')
        @two_hits_data_url = @base_url + URI.encode_www_form_component('講座')
        @one_hit_res = JSON.parse(Net::HTTP.get(URI.parse(@one_hit_data_url)))
        @two_hits_res = JSON.parse(Net::HTTP.get(URI.parse(@two_hits_data_url)))
      end

      it '該当するデータが1個の場合、1個のデータを返すこと' do
        expect(@one_hit_res['subjects'][0]['title']).to eq("悪霊・鬼の倒し方実践講座")
      end

      it '該当するデータが2個の場合、2個のデータを返すこと' do
        expect(@two_hits_res['subjects'][0]['title']).to eq("グレートなティーチャーになるための教育論講座")
        expect(@two_hits_res['subjects'][1]['title']).to eq("悪霊・鬼の倒し方実践講座")
      end

      it 'ステータスコードが200であること' do
        get @one_hit_data_url
        expect(response).to have_http_status(200)
        get @two_hits_data_url
        expect(response).to have_http_status(200)
      end
    end

    #searchアクションのケース3のテスト
    context '検索キーワードがTeacher(教師)のみで該当するとき' do
      before do
        @one_hit_data_url = @base_url + URI.encode_www_form_component('鬼塚')
        @two_hits_data_url = @base_url + URI.encode_www_form_component('先生')
        @one_hit_res = JSON.parse(Net::HTTP.get(URI.parse(@one_hit_data_url)))
        @two_hits_res = JSON.parse(Net::HTTP.get(URI.parse(@two_hits_data_url)))
      end

      context '該当するデータが1個の場合' do
        it '1個のデータを返すこと' do
          expect(@one_hit_res['subjects'][0]['teacher']['name']).to eq("鬼塚先生")
        end

        it 'ステータスコードが200であること' do
          get @one_hit_data_url
          expect(response).to have_http_status(200)
        end

        it 'Lectureが開講年月日(date)において昇順にソートされていること' do
          lectures = @one_hit_res['subjects'][0]['lectures'].map {|l| l['date']}
          expect(lectures).to eq(["2021-04-12", "2021-04-19"])
        end
      end

      context '該当するデータが2個の場合' do
        it '2個のデータを返すこと' do
          expect(@two_hits_res['subjects'][0]['teacher']['name']).to eq("鬼塚先生")
          expect(@two_hits_res['subjects'][2]['teacher']['name']).to eq("鵺野先生")  #######あとで2->1直す
        end

        it 'ステータスコードが200であること' do
          get @two_hits_data_url
          expect(response).to have_http_status(200)
        end

        it 'Lectureの開講年月日(date)において昇順にソートされていること' do
          lectures = @two_hits_res['subjects'][0]['lectures'].map {|l| l['date']}
          expect(lectures).to eq(["2021-04-12", "2021-04-19"])
        end
      end
    end

    #searchアクションのケース4のテスト
    context '検索キーワードが両方に該当するとき' do
      before do
        @both_hits_data_url = @base_url + URI.encode_www_form_component('鬼')
      end
      it '該当するデータすべてを返すこと' do
        uri = URI.parse(@both_hits_data_url)
        res = JSON.parse(Net::HTTP.get(uri))
        expect(res['subjects'][0]['title']).to eq("悪霊・鬼の倒し方実践講座")
        expect(res['subjects'][1]['teacher']['name']).to eq("鬼塚先生")
        expect(res['subjects'][2]['teacher']['name']).to eq("鬼塚先生")  #######あとで消す
      end
      it 'ステータスコードが200であること' do
        get @both_hits_data_url
        expect(response).to have_http_status(200)
      end
      it 'Lectureの開講年月日(date)において昇順にソートされていること' do
        uri = URI.parse(@both_hits_data_url)
        res = JSON.parse(Net::HTTP.get(uri))
        lectures = res['subjects'][1]['lectures'].map {|l| l['date']}
        expect(lectures).to eq(["2021-04-12", "2021-04-19"])
      end
    end


    xit 'subject(科目)が2つであること' do
      expect(Lecture.all).to eq(20)
    end
  end

  #エラー関係のテスト
  describe 'GET /api/v1/subjects?keyword=' do
    context 'keywordが入力されてなかったとき' do
      it 'エラー文を表示すること' do
        get '/api/v1/subjects?keyword='
        expect(response.body).to include("keywordが空白です")
      end
    end
  end
  describe 'GET /api/v1/subjects' do
    context 'リクエストが間違っているとき' do
      it 'エラー文を表示すること' do
        get '/api/v1/subjects'
        expect(response.body).to include("リクエストが間違っています")
      end
    end
  end
end