# module Api
#   module V1
    class SubjectsController < ApplicationController
      #基本7アクションは必要であれば適宜実装

      #定義元はSubjectモデル内に記載
      def search
        #リクエストを「keyword」として受け取ってSubjectモデルで定義したsearchメソッドで検索
        subject_arrays = Subject.search(params[:keyword])
        teacher_arrays = Teacher.all
        lecture_arrays = Lecture.all

        @results = [] #json形式にした最終出力を収納
        lecture_json_format_arrays = [] #lectureを指定のjson形式にしたものを収納

        #subjectのIDにマッチしたものをピックアップ
        subject_arrays.each do |sub_array|
          teacher_matched_subject = teacher_arrays.find_by(teacher_id: sub_array.teacher_id)
          lectures_matched_subject = lecture_arrays.where(subject_id: sub_array.subject_id)

          #lecture_matched_subjectの配列全てを指定のjson形式にする
          lectures_matched_subject.each do |lec|
            lecture_data = {
              id: lec.lecture_id,
              title: lec.title,
              date: lec.date,
            }
            lecture_json_format_arrays << lecture_data
          end

          #subjectとteacherも指定のjson形式にして先程のlecture配列も合わせて@resultに収納
          subject_and_teacher_json_format_arrays = {
            id: sub_array.subject_id,
            title: sub_array.title,
            weekday: sub_array.weekday,
            period: sub_array.period,
            teacher: {
              id: teacher_matched_subject.teacher_id,
              name: teacher_matched_subject.name,
            },
            lectures: lecture_json_format_arrays
          }
          @results << subject_and_teacher_json_format_arrays
        end

        render json: {
          subjects: @results
        }, status: :ok
      end
    end
#   end
# end
