require 'rails_helper'
require 'net/http'

RSpec.describe '#search' do
  describe 'GET /api/v1/subjects?keyword=◯◯◯' do
    context 'subject(科目)の部分一致検索で該当するものがあるとき' do
      it '該当するデータを出力すること' do
        uri = URI.parse('http://localhost:3000/api/v1/subjects?keyword=' + URI.encode_www_form_component('悪霊'))
        res = Net::HTTP.get(uri)
        hash = JSON.parse(res)
        expect(hash['subjects']['title']).to eq("悪霊の倒し方実践講座")
      end
    end

    context 'teacher(教師)の部分一致検索で該当するものがあるとき' do
      it '該当するデータを出力すること' do
        uri = URI.parse('http://localhost:3000/api/v1/subjects?keyword=' + URI.encode_www_form_component('鬼'))
        res = Net::HTTP.get(uri)
        hash = JSON.parse(res)
        expect(hash['subjects']['teacher']['name']).to eq("鬼塚英吉")
      end
    end

    context 'subjectの検索で該当するものがないとき' do
      it '検索結果がない旨を表示すること' do
        get '/api/v1/subjects?keyword=' + URI.encode_www_form_component('殺せんせー')
        expect(response.body).to eq("該当する科目はありません")
      end
    end

    xit 'searchしたResponseがlectureの開講年月日(date)において昇順にソートされていること'
    xit '検索でステータスコードが200であること'
    xit 'subject(科目)が2つであること' do
      uri = URI.parse('http://localhost:3000/api/v1/subjects/')
      res = Net::HTTP.get(uri)
      hash = JSON.parse(res)
      expect(hash['subjects'].length).to eq(2)
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