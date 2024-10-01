module Web.View.Posts.Show where
import Web.View.Prelude
import qualified Text.MMark as MMark


data ShowView = ShowView { post :: Include "comments" Post }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>{post.title}</h1>
        <p>{post.createdAt |> timeAgo}</p>
        <p>{post.body |> renderMarkdown}</p>
        <div> <!-- Comments -->
          <p><a href = {NewCommentAction post.id}>Add a comment</a></p>
          <h2> Comments </h2>
          <div>{forEach post.comments renderComment}</div>
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Posts" PostsAction
                            , breadcrumbText "Show Post"
                            ] 


renderMarkdown text = 
  case text |> MMark.parse "" of
    Left error -> "Error Parsing Markdown"
    Right markdown -> MMark.render markdown |> tshow |> preEscapedToHtml

renderComment comment = [hsx| 
          <div>
            <span><b> {comment.author}</b> </span> <span> &nbsp; &nbsp; {comment.createdAt |> timeAgo } </span>
            <p> {comment.body} </p>
          </div>
      |]
