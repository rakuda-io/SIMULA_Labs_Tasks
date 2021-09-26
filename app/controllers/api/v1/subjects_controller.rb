module Api
  module V1
    class SubjectsController < ApplicationController
      def search #searchアクションの定義元はSubjectモデル・Teacherモデル内にそれぞれ記載

        #リクエストエラーの早期リターンパターン
        if params[:keyword].nil?
          return render status: 400,
          json: "●WARNING●: \r\n リクエストが間違っています。\r\n\r\n  localhost:3000/api/v1/subjects?keyword=◯◯ \r\n の形式で◯◯に検索語句を含めてリクエストを送ってください"
        elsif params[:keyword] == ""
          return render status: 400,
          json: "●WARNING●: \r\n keywordが空白です。\r\n\r\n  localhost:3000/api/v1/subjects?keyword=◯◯ \r\n の形式で◯◯に検索語句を含めてリクエストを送ってください"
        end

        #リクエストを「keyword」として受け取ってsearchメソッドで検索処理をかけ各配列に収納
        subject_arrays = Subject.search(params[:keyword])
        teacher_arrays = Teacher.search(params[:keyword])
        lecture_arrays = Lecture.all.order(date: :asc) #lectureの日付を昇順にソート

        #最終結果を収納する配列を用意
        json_format_datas = []

        #ケース1 Subject、Teacher共に検索条件に該当がない場合（早期リターン）
        if subject_arrays.empty? && teacher_arrays.empty?
          return render status: 200,
          json: "該当する科目はありません"

        #ケース2 Subjectで検索条件がヒットした場合
        elsif subject_arrays.present? && teacher_arrays.empty?
          #Subjectの各IDにマッチしたものをピックアップ
          subject_arrays.each do |sub_data|
            teacher_matched_subject = Teacher.find_by(teacher_id: sub_data.teacher_id)
            lectures_matched_subject = lecture_arrays.where(subject_id: sub_data.subject_id)

            #科目内の授業一覧（lecture_matched_subject）の配列全てをひとつずつ指定のjson形式にする
            lectures = lectures_matched_subject.map do |lec|
              {
                id: lec.lecture_id,
                title: lec.title,
                date: lec.date,
              }
            end

            #SubjectとTeacherも指定のjson形式にして先程のjson形式にしたlecturesも合わせた配列を収納
            json_format_datas << {
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
          teacher_arrays.each do |tea_data|
            subjects_matched_teacher = Subject.where(teacher_id: tea_data.teacher_id)

            subjects_matched_teacher.each do |smt|
              lectures_matched_teacher = lecture_arrays.where(subject_id: smt.subject_id)

              lectures = lectures_matched_teacher.map do |lec|
                {
                  id: lec.lecture_id,
                  title: lec.title,
                  date: lec.date,
                }
              end

              #SubjectとTeacherも指定のjson形式にして先程のjson形式にしたlecturesも合わせた配列を収納
              json_format_datas << {
                id: smt.subject_id,
                title: smt.title,
                weekday: smt.weekday,
                period: smt.period,
                teacher: { #teacher_arraysから各項目をpluckして配列化、sliceで取り出し
                    id: tea_data.teacher_id,
                    name: tea_data.name,
                },
                lectures: lectures
              }

            end
          end

        elsif subject_arrays.present? && teacher_arrays.present?


        #ケース4 想定外のエラーが起きている場合
        else
          return render status: 404,
          json: "●ERROR●: \r\n 想定外のエラー \r\n\r\n API制作担当にご連絡ください。 \r\n 連絡先：090-xxxx-xxxx"
        end

        #各ケースで保存したjsonデータをrenderで表示
        render json: {
          subjects: json_format_datas
        }, status: :ok

      end
    end
  end
end