module Api
  module V1
    class SubjectsController < ApplicationController
      def search #searchアクションの定義元はSubjectモデル・Teacherモデル内にそれぞれ記載

        #早期リターンパターン
        return render json: "●WARNING●: \r\n リクエストが間違っています。\r\n\r\n  localhost:3000/api/v1/subjects?keyword=◯◯ \r\n の形式で◯◯に検索語句を含めてリクエストを送ってください" if params[:keyword].nil?
        return render json: "●WARNING●: \r\n keywordが空白です。\r\n\r\n  localhost:3000/api/v1/subjects?keyword=◯◯ \r\n の形式で◯◯に検索語句を含めてリクエストを送ってください" if params[:keyword] == ""

        @results = [] #json形式にした最終出力を収納

        #リクエストを「keyword」として受け取ってsearchメソッドで検索処理をかけ各配列に収納
        subject_arrays = Subject.search(params[:keyword])
        teacher_arrays = Teacher.search(params[:keyword])

        #ケース1 Subject、Teacher共に検索条件に該当がない場合（早期リターン）
        if subject_arrays.empty? && teacher_arrays.empty?
          return render json: "該当する授業はありません"

        #ケース2 Subjectで検索条件がヒットした場合
        elsif subject_arrays.present? && teacher_arrays.empty?
          teacher_arrays = Teacher.all
          lecture_arrays = Lecture.all.order(date: :asc) #lectureの日付を昇順にソート

          #Subjectの各IDにマッチしたものをピックアップ
          subject_arrays.each do |sub_data|
            teacher_matched_subject = teacher_arrays.find_by(teacher_id: sub_data.teacher_id)
            lectures_matched_subject = lecture_arrays.where(subject_id: sub_data.subject_id)

            #科目内の授業一覧（lecture_matched_subject）の配列全てをひとつずつ指定のjson形式にする
            lectures = [] #指定のjson形式にしたものをひとつずつ収納
            lectures_matched_subject.each do |lec|
              lecture_data = {
                id: lec.lecture_id,
                title: lec.title,
                date: lec.date,
              }
              lectures << lecture_data
            end

            #SubjectとTeacherも指定のjson形式にして先程のjson形式にしたlecturesも合わせたものを収納
            @json_format_datas = {
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
          end

        #ケース3 Teacherで検索条件がヒットした場合
        elsif subject_arrays.empty? && teacher_arrays.present?
          subject_matched_teacher = Subject.find_by(teacher_id: teacher_arrays.pluck(:teacher_id))
          lecture_arrays = Lecture.all.order(date: :asc) #lectureの日付を昇順にソート
          lectures_matched_subject = lecture_arrays.where(subject_id: subject.teacher_id)

          lectures = [] #指定のjson形式にしたものをひとつずつ収納
          lectures_matched_subject.each do |lec|
            lecture_data = {
              id: lec.lecture_id,
              title: lec.title,
              date: lec.date,
            }
            lectures << lecture_data
          end

          #subjectとteacherも指定のjson形式にして先程のlecture配列も合わせて@resultに収納
          @json_format_datas = {
            id: subject_matched_teacher.subject_id,
            title: subject_matched_teacher.title,
            weekday: subject_matched_teacher.weekday,
            period: subject_matched_teacher.period,
            teacher: {
                id: teacher_arrays.pluck(:teacher_id).slice(0),
                name: teacher_arrays.pluck(:name).slice(0),
            },
            lectures: lectures
          }
        end

        render json: {
          subjects: @json_format_datas
        }, status: :ok

      end
    end
  end
end