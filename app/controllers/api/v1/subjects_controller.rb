module Api
  module V1
    class SubjectsController < ApplicationController
      def index ##DBの中身確認用 localhost:3000/api/v1/subjects/
        subject_arrays = Subject.all
        teacher_arrays = Teacher.all
        lecture_arrays = Lecture.all.order(date: :asc) #lectureの日付を昇順にソート
        @results = []
        subject_arrays.each do |sub|
          teacher_matched_subject = teacher_arrays.find_by(teacher_id: sub.teacher_id)
          lectures_matched_subject = lecture_arrays.where(subject_id: sub.subject_id)
            json_format_datas = {
              id: sub.subject_id,
              title: sub.title,
              weekday: sub.weekday,
              period: sub.period,
              teacher: {
                id: teacher_matched_subject.teacher_id,
                name: teacher_matched_subject.name,
              },
              lectures: lectures_matched_subject.select(:lecture_id, :title, :date)
            }
          @results << json_format_datas
        end

        render json: {
          subjects: @results
        }, status: :ok
      end

      def search #searchアクションの定義元はSubjectモデル・Teacherモデル内にそれぞれ記載
        #早期リターンパターン
        return render json: "●WARNING●: \r\n リクエストが間違っています。\r\n\r\n  localhost:3000/api/v1/search/?keyword=◯◯ \r\n の形式で◯◯に検索語句を含めてリクエストを送ってください" if params[:keyword].nil?
        return render json: "●WARNING●: \r\n keywordが空白です。\r\n\r\n  localhost:3000/api/v1/search/?keyword=◯◯localhost:3000/api/v1/search/?keyword=◯◯ \r\n の形式で◯◯に検索語句を含めてリクエストを送ってください" if params[:keyword] == ""

        @results = [] #json形式にした最終出力を収納

        #リクエストを「keyword」として受け取ってApplication_recordモデルで定義したsearchメソッドで検索
        subject_arrays = Subject.search(params[:keyword])
        teacher_arrays = Teacher.search(params[:keyword])

        #ケース1 Subject、Teacher共に検索条件に該当がない場合
        if subject_arrays.empty? && teacher_arrays.empty?
          return render json: "該当する授業はありません" #早期リターン

        #ケース2 Subjectで検索条件がヒットした場合
        elsif subject_arrays.present? && teacher_arrays.empty?
          teacher_arrays = Teacher.all
          lecture_arrays = Lecture.all.order(date: :asc) #lectureの日付を昇順にソート
                  #subjectのIDにマッチしたものをピックアップ
          subject_arrays.each do |sub_data|
            teacher_matched_subject = teacher_arrays.find_by(teacher_id: sub_data.teacher_id)
            lectures_matched_subject = lecture_arrays.where(subject_id: sub_data.subject_id)

            #lecture_matched_subjectの配列全てを指定のjson形式にする
            lectures = [] #lectureを指定のjson形式にしたものを収納
            lectures_matched_subject.each do |lec|
              lecture_data = {
                id: lec.lecture_id,
                title: lec.title,
                date: lec.date,
              }
              lectures << lecture_data
            end

            #subjectとteacherも指定のjson形式にして先程のlecture配列も合わせて@resultに収納
            json_format_datas = {
              id: sub_data.subject_id,
              title: sub_data.title,
              weekday: sub_data.weekday,
              period: sub_data.period,
              teacher: {
                  id: teacher_matched_subject.teacher_id,
                  name: teacher_matched_subject.name,
              },
              lectures: lectures
            }
            @results << json_format_datas
          end

        #ケース3 Teacherで検索条件がヒットした場合
        elsif subject_arrays.empty? && teacher_arrays.present?
          subject = Subject.find_by(teacher_id: teacher_arrays.pluck(:teacher_id))
          lecture_arrays = Lecture.all.order(date: :asc) #lectureの日付を昇順にソート
          lectures_matched_subject = lecture_arrays.where(subject_id: subject.teacher_id)
          lectures = [] #lectureを指定のjson形式にしたものを収納
          lectures_matched_subject.each do |lec|
            lecture_data = {
              id: lec.lecture_id,
              title: lec.title,
              date: lec.date,
            }
            lectures << lecture_data
          end

          #subjectとteacherも指定のjson形式にして先程のlecture配列も合わせて@resultに収納
          json_format_datas = {
            id: subject.subject_id,
            title: subject.title,
            weekday: subject.weekday,
            period: subject.period,
            teacher: {
                id: teacher_arrays.pluck(:teacher_id).slice(0),
                name: teacher_arrays.pluck(:name).slice(0),
            },
            lectures: lectures
          }
          @results << json_format_datas
        end

        render json: {
          subjects: @results
        }, status: :ok

      end
    end
  end
end