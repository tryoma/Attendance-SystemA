module AttendancesHelper

  def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出社' if attendance.started_at.nil?
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    false
  end
  
  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
  
  # 終了時間と終了予定時間を受け取り、時間外時間を計算して返します。
  def over_working_times(plan_finish, finish)
    format("%.2f", (((plan_finish - finish ) / 60) / 60.0))
  end
  
  # 終了時間と終了予定時間を受け取り、時間外時間を計算して返します。翌日の場合。
  def next_day_over_working_times(plan_finish, finish)
    format("%.2f", ((((plan_finish - finish ) / 60) + 24)/ 60.0))
  end
end