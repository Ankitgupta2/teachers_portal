class StudentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @student = Student.new
    @students = Student.all
  end

  def new
    @student = Student.new
  end

  def create
    existing_student = Student.find_by(name: student_params[:name], subject: student_params[:subject])

    if existing_student
      existing_student.marks = student_params[:marks].to_i
      if existing_student.save
        redirect_to students_path, notice: 'Marks updated successfully.'
      else
        render :new, alert: 'Failed to update marks.'
      end
    else
      @student = Student.new(student_params)
      if @student.save
        redirect_to students_path, notice: 'Student was successfully created.'
      else
        render :new
      end
    end
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])
    if @student.update(student_params)
      redirect_to students_path, notice: 'Student was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    redirect_to students_path, notice: 'Student was successfully deleted.'
  end

  private

  def student_params
    params.require(:student).permit(:name, :subject, :marks)
  end
end