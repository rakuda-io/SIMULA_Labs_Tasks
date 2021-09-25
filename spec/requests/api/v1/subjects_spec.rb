require 'rails_helper'
require 'net/http'

RSpec.describe 'Syllabus API' do
  describe 'GET /api/v1/subjects' do
    it '全データ表示でステータスコードが200であること' do
      get '/api/v1/subjects'
      expect(response).to have_http_status(200)
    end

    it 'subject(科目)が2つであること' do
      uri = URI.parse('http://localhost:3000/api/v1/subjects/')
      res = Net::HTTP.get(uri)
      hash = JSON.parse(res)
      expect(hash['subjects'].length).to eq(2)
    end
  end

  describe 'GET /api/v1/subjects/search/?keyword=◯◯◯' do
    context 'subject(科目)の部分一致検索で該当するものがあるとき' do
      it '該当するデータを出力すること' do
        uri = URI.parse('http://localhost:3000/api/v1/subjects/search/?keyword=' + URI.encode_www_form_component('悪霊'))
        res = Net::HTTP.get(uri)
        hash = JSON.parse(res)
        expect(hash['subjects'][0]['teacher']['name']).to include("鵺野鳴介")
      end
    end

    context 'teacher(教師)の部分一致検索で該当するものがあるとき' do
      it '該当するデータを出力すること' do
        uri = URI.parse('http://localhost:3000/api/v1/subjects/search/?keyword=' + URI.encode_www_form_component('鬼'))
        res = Net::HTTP.get(uri)
        hash = JSON.parse(res)
        expect(hash['subjects'][0]['title']).to include("グレートなティーチャー")
      end
    end

    context 'subjectの検索で該当するものがないとき' do
      it 'エラー文を表示すること' do
        get '/api/v1/subjects/search/?keyword=' + URI.encode_www_form_component('殺せんせー')
        expect(response.body).to eq("該当する授業はありません")
      end
    end

    it 'searchしたResponseがlectureの開講年月日(date)において昇順にソートされていること'
    it '検索でステータスコードが200であること'
  end

  describe 'GET /api/v1/subjects/search' do
    context 'リクエストが間違っているとき' do
      it 'エラー文を表示すること' do
        get '/api/v1/subjects/search'
        expect(response.body).to include("リクエストが間違っています")
      end
    end
  end
  describe 'GET /api/v1/subjects/search/?keyword=' do
    context 'keywordが入力されてなかったとき' do
      it 'エラー文を表示すること' do
        get '/api/v1/subjects/search/?keyword='
        expect(response.body).to include("keywordが空白です")
      end
    end
  end
end