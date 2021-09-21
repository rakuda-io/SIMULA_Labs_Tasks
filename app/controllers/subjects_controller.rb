# module Api
#   module V1
    class SubjectsController < ApplicationController
      def index
        subs = Subject.all
        teas = Teacher.all
        lecs = Lecture.all.select(:lecture_id, :title, :date)
        @results = []
        subs.each do |sub|
          @tea = teas.find_by(teacher_id: sub.teacher_id)
          @lec = lecs.where(subject_id: sub.subject_id)
            data = {
              id: sub.subject_id,
              title: sub.title,
              weekday: sub.weekday,
              period: sub.period,
              teacher: {
                id: @tea.teacher_id,
                name: @tea.name,
              },
              lectures: @lec.select(:lecture_id, :title, :date)
            }
          @results << data
        end
        @result = { subjects: @results }
        render json: @result
      end

      # def search
      #   if params[:title].blank?
      #     render json: [{"error": "100", "msg": "必須パラメーターがありません", "required": {"key": "name"}}]
      #   else
      #     @result = Character.where("name like ?", "%" + params[:name] + "%")
      #     @result += Character.where("phonetic like ?", "%" + params[:name] + "%")


      #     render json: @result
      #   end
      # end
    end
#   end
# end
