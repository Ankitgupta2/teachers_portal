class Student < ApplicationRecord
    validates :name, :subject, :marks, presence: true
end
