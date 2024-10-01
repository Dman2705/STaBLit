module Web.FrontController where

import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.View.Layout (defaultLayout)

import IHP.LoginSupport.Middleware

-- Controller Imports
import Web.Controller.Users
import Web.Controller.Comments
import Web.Controller.Posts
import Web.Controller.Static

import Web.Controller.Sessions

instance FrontController WebApplication where
    controllers = 
        [ startPage PostsAction
        -- Generator Marker
        , parseRoute @UsersController
        , parseRoute @CommentsController
        , parseRoute @PostsController
        , parseRoute @SessionsController
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
        initAutoRefresh
        initAuthentication @User
