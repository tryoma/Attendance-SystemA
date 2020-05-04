class Attendance < ApplicationRecord
  belongs_to :user

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  
  # 出勤時間が存在しない場合、退勤時間は無効(applying)
  validate :applying_finished_at_is_invalid_without_a_started_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効(applying)
  validate :applying_started_at_than_applying_finished_at_fast_if_invalid


  # 出勤時間が存在しない場合、退勤時間は無効(Normal)
  validate :finished_at_is_invalid_without_a_started_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効(Normal)
  validate :started_at_than_finished_at_fast_if_invalid

  #(applying)
  def applying_finished_at_is_invalid_without_a_started_at
    errors.add(:applying_started_at, "が必要です") if applying_started_at.blank? && applying_finished_at.present?
  end

  def applying_started_at_than_applying_finished_at_fast_if_invalid
    if applying_started_at.present? && applying_finished_at.present?
      errors.add(:applying_started_at, "より早い退勤時間は無効です") if applying_started_at > applying_finished_at
    end
  end
  
  #(Normal)
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end

  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
  end
end