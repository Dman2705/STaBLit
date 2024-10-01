module Web.View.Posts.Index where
import Web.View.Prelude

data IndexView = IndexView { posts :: [Post] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb} 
        <a href={NewUserAction}>Create Account</a> &nbsp; &nbsp; 
        <a href={NewSessionAction}>Login</a> &nbsp; &nbsp; 
        <a class="js-delete js-delete-no-confirm" href={DeleteSessionAction}>Logout</a> &nbsp; &nbsp; 
        <span> { loggedInStatus currentUserOrNothing } </span>

        <h1>Index<a href={pathTo NewPostAction} class="btn btn-primary ms-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Post</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach posts renderPost}</tbody>
            </table>
            
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Posts" PostsAction
                ]

renderPost :: Post -> Html
renderPost post = [hsx|
    <tr>
        <td><a href = {ShowPostAction post.id}>{post.title}</a></td>
        <td><a href={EditPostAction post.id} class="text-muted">Edit</a></td>
        <td><a href={DeletePostAction post.id} class="js-delete text-muted">Delete</a></td>
        <td>{post.createdAt |> timeAgo}</td>
    </tr>
|]


loggedInStatus :: Maybe User -> Text
loggedInStatus currentUserOrNothing = 
  case currentUserOrNothing of 
    Just user -> "Currently logged in with: " ++ user.email
    Nothing -> "Currently logged out"
                