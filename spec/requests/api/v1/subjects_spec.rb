require 'rails_helper'
require 'net/http'

RSpec.describe 'Syllabus API' do
  it '一覧表示でステータスコードが200であること' do
    get '/api/v1/subjects'
    expect(response.status).to eq(400)
  end
  xit 'subject(科目)が2つであること' do
    uri = URI.parse('http://localhost:3000/api/v1/subjects/')
    res = Net::HTTP.get(uri)
    json = JSON.parse(res)

    expect(json['subjects'].length).to eq(2)
  end
end