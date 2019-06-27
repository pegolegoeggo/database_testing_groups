class DocumentsController < ApplicationController
	def index
		if params['search']
			@documents = Document.where(["title LIKE ?", "%#{params['search']}%"])
		else
			@documents = Document.all
		end
	end

	def show
		if (params.has_key?(:id))
			@id = params['id']
			@title = Document.find(@id).title
			@body = Document.find(@id).body
			@groups = Document.find(@id).groups
			

			respond_to do |format|
		      format.html # show.html.erb
		      format.xml  { render :xml => @document }
    		end
		end
  	end
	
	def new
		@document = Document.new
		@documents = Document.all
		if person_signed_in?
			@groups = Person.find(current_person.id).groups
		# puts @groups
		end

		respond_to do |format|
     		format.html # new.html.erb
     		format.xml  { render :xml => @document }
   		end

	end

	def create 
		@document = Document.new(document_params)
		# params['groups'].each do |k|
		# 	@document.groups << Group.find_by_name(k)
		# end
		@checked = params['groups']
		@document.groups << Group.find(@checked)

		if @document.save
			# # @document.groups << @groups
			redirect_to new_document_path
		else
			render :new
		end
	end

	def update
	    # params[:document][:group_id] ||= []
	    @document = Document.find(params['id'])
	 #    params['groups'].each do |k|
		# 	@document.groups << Group.find_by_name(k)
		# end
		#params = what's being passed from the form 
		@checked = params['groups']
		# @alreadyInGroup = false
		
		#ensures document is only added to the group once. 
		#alternate solution: specify custom primary key on join table
		begin
			@document.groups.find(@checked)
			
		rescue ActiveRecord::RecordNotFound
			@document.groups << Group.find(@checked)
			
		else
		puts "ERROR"
		end
		# else
		# 	@document.groups << Group.find(@checked)
		# end

	    respond_to do |format|
	      if @document.update_attributes(document_params)
	        format.html { redirect_to(@document, :notice => 'Document was successfully updated.') }
	        format.xml  { head :ok }
	      else
	        render :edit
	    
	      end
	    end
	end

	def edit
		#db calls
	    # @groups = Group.all
	    @groups = Person.find(current_person.id).groups
	    @document = Document.find(params['id'])
	    @documents = Document.all
	    @current_groups = @document.groups
	    # puts @current_group.nil?

	    #usually works with just first clause but needed 2nd part for document id = 9?
	    if !@current_groups.nil? && @current_groups.length > 0 
	    	puts "has current groups"
		    @first = @current_groups.first.id
		else
			@first = @groups.first.id
			puts "no groups"
		end
 	end

	private 

	def document_params
		#changing stuff in db needs to permit 
	    params.require(:document).permit(:title, :body, groups: :group_id)
	end


end
