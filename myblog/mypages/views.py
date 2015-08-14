from django.http import HttpResponseRedirect
from django.contrib.auth.decorators import user_passes_test
from django.shortcuts import redirect, render_to_response, get_object_or_404,render
from django.template import RequestContext
from models import Post
from django.contrib import auth
from django.core.context_processors import csrf
from forms import PostForm, CommentForm
from django.contrib.auth.forms import  UserCreationForm

@user_passes_test(lambda u: u.is_authenticated())
def add_post(request):
    form = PostForm(request.POST or None,request.FILES or None)
    if form.is_valid():
        post = form.save(commit=False)
        post.author = request.user
        post.save()
        return redirect(post)
    return render_to_response('add_post.html', 
                              { 'form': form },
                              context_instance=RequestContext(request))


@user_passes_test(lambda u: u.is_staff)
def delete_post(request,slug):

    post = Post.objects.get(slug=slug).delete()
    
    return HttpResponseRedirect('/edit_articles/')

@user_passes_test(lambda u: u.is_authenticated())
def edit_post(request, slug):
    post = get_object_or_404(Post, slug=slug)
    form = PostForm(request.POST or None, instance=post)
    if post.author == request.user :
      if form.is_valid():
              edit = form.save(commit=False)
              edit.post = post
              edit.author = request.user
              edit.save()
              return redirect(post)
      return render_to_response('blog_post_edit.html', 
                                { 
                                    'form': form,
                                    'post': post,
                                },
                                context_instance=RequestContext(request))
     

def articles(request):
    arts=Post.objects.filter(finished=True)
    return render(request,"articles.html",{"articles":arts})


def my_articles(request):
    
    posts=Post.objects.filter(author=request.user)
    return render(request,"my_articles.html",{"posts":posts})

def edit_pages(request):
    
    edits=Post.objects.filter(author=request.user)
    return render(request,"edit_articles.html",{"edits":edits})


def view_post(request, slug):
    post = get_object_or_404(Post, slug=slug)
    form = CommentForm(request.POST or None)

    if form.is_valid():
        
            comment = form.save(commit=False)
            comment.post = post
            comment.save()
            request.session["name"] = comment.name
            request.session["email"] = comment.email
            return redirect(request.path)
    form.initial['name'] = request.session.get('name')
    form.initial['email'] = request.session.get('email')
    form.initial['website'] = request.session.get('website')
    return render_to_response('blog_post.html',
                              {
                                  'post': post,
                                  'form': form,
                              },
                              context_instance=RequestContext(request))

def like_post(request,slug):
  if slug:
    a=Post.objects.get(slug=slug)
    count = a.like
    count += 1
    a.like = count
    a.save()
  return HttpResponseRedirect('/post/%s' % slug )

def search(request):
  if request.method == "POST" :
    search_title = request.POST['search_title']
  else :
    search_title = ''
  posts=Post.objects.filter(title__contains=search_title)
  render_to_response('search.html',{'posts': posts})



def login(request):
      c={}
      c.update(csrf(request))
      return render_to_response('login.html',c)

def auth_view(request):
      username = request.POST.get('username','')
      password = request.POST.get('password','')
      user = auth.authenticate(username=username,password=password)    

      
      if user is not None:
                  
          auth.login(request,user)

          return HttpResponseRedirect('/accounts/loggedin')
      else:
          return HttpResponseRedirect('/accounts/invalid')

def loggedin(request):
        return render_to_response('loggedin.html',{'full_name':request.user.username})


def invalid_login(request):
        return render_to_response('invalid_login.html')
      
def logout(request):
          auth.logout(request)
          return render_to_response('logout.html',{'full_name':request.user.username})


def register_user(request):
      if request.method == 'POST':
        form=UserCreationForm(request.POST)
        if form.is_valid():
            form.save()
            return HttpResponseRedirect('/accounts/register_success',{})

      else:
        args={}
        args.update(csrf(request)) 
        args['form'] = UserCreationForm()
        print args
        return render_to_response('register.html',args)

def register_success(request):
    return render_to_response('register_success.html')