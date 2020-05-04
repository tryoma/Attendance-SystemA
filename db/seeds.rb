# coding: utf-8

User.create!(name: "Sample User",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
             admin: true)
             
User.create!(name: "上長A",
             email: "superior1@email.com",
             affiliation: "人事部",
             employee_number: "1",
             uid: "001",
             password: "password",
             password_confirmation: "password",
             admin: false,
             superior: true)

User.create!(name: "上長B",
             email: "superior2@email.com",
             affiliation: "総務部",
             employee_number: "2",
             uid: "002",
             password: "password",
             password_confirmation: "password",
             admin: false,
             superior: true)
             
User.create!(name: "一般社員A",
             email: "general1@email.com",
             affiliation: "人事部",
             employee_number: "3",
             uid: "003",
             password: "password",
             password_confirmation: "password",
             admin: false,
             superior: false)
             
User.create!(name: "一般社員B",
             email: "general2@email.com",
             affiliation: "人事部",
             employee_number: "4",
             uid: "004",
             password: "password",
             password_confirmation: "password",
             admin: false,
             superior: false)

