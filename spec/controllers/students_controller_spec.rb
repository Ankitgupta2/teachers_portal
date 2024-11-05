require 'rails_helper'

RSpec.describe StudentsController, type: :controller do
  let(:user) { create(:user) } # Assuming you have a User factory
  let!(:student) { create(:student) } # Assuming you have a Student factory

  before do
    sign_in user # Sign in the user for authentication
  end

  describe "GET #index" do
    it "assigns @students" do
      get :index
      expect(assigns(:students)).to eq([student])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "assigns a new student to @student" do
      get :new
      expect(assigns(:student)).to be_a_new(Student)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      let(:valid_attributes) { { name: "John Doe", subject: "Math", marks: 95 } }

      it "creates a new Student" do
        expect {
          post :create, params: { student: valid_attributes }
        }.to change(Student, :count).by(1)
      end

      it "redirects to the students list with a success notice" do
        post :create, params: { student: valid_attributes }
        expect(response).to redirect_to(students_path)
        expect(flash[:notice]).to eq('Student was successfully created.')
      end
    end

    context "with existing student" do
      let!(:existing_student) { create(:student, name: "John Doe", subject: "Math", marks: 90) }
      let(:valid_attributes) { { name: "John Doe", subject: "Math", marks: 95 } }

      it "updates the marks of the existing student" do
        expect {
          post :create, params: { student: valid_attributes }
        }.not_to change(Student, :count)
        expect(existing_student.reload.marks).to eq(95)
      end

      it "redirects to the students list with an update notice" do
        post :create, params: { student: valid_attributes }
        expect(response).to redirect_to(students_path)
        expect(flash[:notice]).to eq('Marks updated successfully.')
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) { { name: "", subject: "", marks: nil } }

      it "does not create a new student" do
        expect {
          post :create, params: { student: invalid_attributes }
        }.not_to change(Student, :count)
      end

      it "renders the new template" do
        post :create, params: { student: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "assigns the requested student to @student" do
      get :edit, params: { id: student.id }
      expect(assigns(:student)).to eq(student)
    end

    it "renders the edit template" do
      get :edit, params: { id: student.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      let(:new_attributes) { { name: "Jane Doe", subject: "Science", marks: 85 } }

      it "updates the requested student" do
        patch :update, params: { id: student.id, student: new_attributes }
        student.reload
        expect(student.name).to eq("Jane Doe")
      end

      it "redirects to the students list with a success notice" do
        patch :update, params: { id: student.id, student: new_attributes }
        expect(response).to redirect_to(students_path)
        expect(flash[:notice]).to eq('Student was successfully updated.')
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) { { name: "", subject: "", marks: nil } }

      it "does not update the student" do
        patch :update, params: { id: student.id, student: invalid_attributes }
        student.reload
        expect(student.name).not_to eq("")
      end

      it "renders the edit template" do
        patch :update, params: { id: student.id, student: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the student" do
      expect {
        delete :destroy, params: { id: student.id }
      }.to change(Student, :count).by(-1)
    end

    it "redirects to the students list with a success notice" do
      delete :destroy, params: { id: student.id }
      expect(response).to redirect_to(students_path)
      expect(flash[:notice]).to eq('Student was successfully deleted.')
    end
  end
end
