class StaticController < ApplicationController
	before_action :authenticate_user! , only: [:check, :category, :categorys ,:welcome]
	def index
    
    if user_signed_in? && current_user.selected_category			
         return redirect_to '/static/welcome'
      elsif user_signed_in? && !current_user.selected_category
        return redirect_to '/static/category'
      end

    end



    def category
      @u = User.find(current_user)
      @c=Category.all
      @c.each do |a| 
       @u.categories << a
       @u.save
     end
   end

   def categorys
     cids = params[:cid]
     x = cids.length
     weight_initital = (100.0/x)
    #uid id the user who selected them
    uid = params[:id]
    
    #w is the array of records of the user in weight table.
    w = Weight.where(:user_id => uid)
    user = User.find(uid)
    user.selected_category = true
    user.save
    w.each do |u|

      if cids.include? u.category_id.to_s
        u.selected = true 
        u.weight_selected = weight_initital
        u.save
      else
        u.selected = false
        u.save
      end

    end
    return redirect_to :controller => :static , :action => :welcome


  end

  def welcome
    @post_temp = sakku
    @user = User.find(current_user)
    @post =[]
    @post_temp.each do |temp|

    @post << Post.find(temp.first)
    end
    
    @post_all  = Post.all
    @cat = Category.all
    @c=Category.all


    
  end

  def add_post
    @u=User.find(current_user)
    @c=Category.all
  end

  def add_postp
    title = params[:title]
    content = params[:content]
    cid = params[:cid]
    uid = params[:id]
    u = User.find(uid)
    c = Category.find(cid)
    post = Post.create(:title => title, :content => content, 
      :user_id => u.id, :category_id => c.id)
    
    w = Weight.where(:user_id => uid)
    w.each do |w|
      if w.category_id == c.id
        w.posts = w.posts + 1
        w.save
      end
    end

    return redirect_to :controller => :static , :action => :welcome
  end

  def like
    uid = params[:uid]
    cid = params[:cid]
    pid = params[:pid]
    vote = Upvote.where(:user_id => uid , :post_id => pid)
    w = Weight.where(:user_id => uid , :category_id => cid)
    post = Post.find(pid)
    if vote.exists?
      vote.delete_all
      w.each do |w|
        w.likes = w.likes - 1
        w.save
      end
      post.nol = post.nol - 1
      post.save
    else
      vote = Upvote.create(:user_id => uid , :post_id => pid)
      vote.save
      w.each do |w|
        w.likes = w.likes + 1
        w.save
      end
      post.nol = post.nol + 1
      post.save
    end

    return redirect_to :controller => :static , :action => :welcome   
  end

  
  def like_cat
    uid = params[:uid]
    cid = params[:cid]
    pid = params[:pid]
    vote = Upvote.where(:user_id => uid , :post_id => pid)
    w = Weight.where(:user_id => uid , :category_id => cid)
    post = Post.find(pid)
    if vote.exists?
      vote.delete_all
      w.each do |w|
        w.likes = w.likes - 1
        w.save
      end
      post.nol = post.nol - 1
      post.save
    else
      vote = Upvote.create(:user_id => uid , :post_id => pid)
      vote.save
      w.each do |w|
        w.likes = w.likes + 1
        w.save
      end
      post.nol = post.nol + 1
      post.save
    end

    return redirect_to :controller => :static , :action => :show_category , :id => cid

  end
  def category_post
    @user = User.find(current_user)
            @c=Category.all
            
                if request.post?
  #handle posts
              cid = params[:cid]
            
    end        
  #handle gets
  @post = Post.where(category_id: cid)

  end
  def show_category
    cid = params[:id]
    @cat = Category.find(cid)
    @post = Post.where(category_id: cid)
    @user = User.find(current_user)
  end
  def show_post
    @p = Post.find(params[:id])
    @user = User.find(current_user)
  end

  private

  def sakku
    pseudo_posts = Post.where("created_at >= ?", Time.zone.now.beginning_of_day)
    selected_category = []
    if user_signed_in? && current_user.selected_category      
      wt = Weight.where(:user_id => current_user)
      sum = 0
      wt.each do |w|
        if w.selected == true
          selected_category << w.category_id
          w.category_table_weight_new = (0.9 * w.posts ) + (0.1 * w.likes)
          w.save
          sum = sum + w.category_table_weight_new
        else
          w.category_table_weight_new = 0
          w.save
        end
      end
    end
      
    flag = false
    wt.each do |w|
      if w.selected == true
        temp = w.relative_ratio
        if sum !=0
          w.relative_ratio = (w.category_table_weight_new/sum ) * 100
          if w.relative_ratio != temp
            flag = true
          end
        else
        w.relative_ratio = 0
        end
      end
    end

    if flag
      wt.each do |w|
        if w.selected == true
          w.weight_selected_final = (0.99 * w.weight_selected) + (0.01 * w.relative_ratio)
          w.weight_selected = w.weight_selected_final
          w.save
        else
          w.relative_ratio = nil
          w.save
        end
      end
    end


       
    rest_post = []
    final_post = []
    pseudo_posts.each do |p|
      if selected_category.include? p.category_id
          #inside pseudo table insert these p
          #and assign final weight acc to algo
          #sort this table
          #pass this to view

          final_post << p
      else 
        rest_post << p
      end

    end

    old_posts = Post.where("created_at < ?", Time.zone.now.beginning_of_day)
    old_posts.reverse_order!.reverse_order!

      my_hash = {}
      
      final_post.each do |f|
        lol = Weight.where( :user_id => current_user , :category_id => f.category_id)
        u = lol.first
        
        if f.nol==0
          final_weight = u.weight_selected
        else
          final_weight = u.weight_selected * f.nol
        end

        my_hash[f.id] = final_weight

      end
      
      rest_post.each do |f|
        lol = Weight.where( :user_id => current_user , :category_id => f.category_id)
        u = lol.first
        
        final_weight = f.nol 
        my_hash[f.id] = final_weight
      end

      old_posts.each do |f|
        lol = Weight.where( :user_id => current_user , :category_id => f.category_id)
        u = lol.first
        
        final_weight = -1
        my_hash[f.id] = final_weight
      end

      my_hash = my_hash.sort_by {|_key, value| value}.to_h
      
      return my_hash
    end

 end
