module Web.Controller.Users where

import Web.Controller.Prelude
import Web.View.Users.Index
import Web.View.Users.New
import Web.View.Users.Edit
import Web.View.Users.Show

instance Controller UsersController where
    action UsersAction = do
        users <- query @User |> fetch
        render IndexView { .. }

    action NewUserAction = do
        let user = newRecord
        render NewView { .. }

    action ShowUserAction { userId } = do
        user <- fetch userId
        render ShowView { .. }

    action EditUserAction { userId } = do
        user <- fetch userId
        render EditView { .. }

    action UpdateUserAction { userId } = do
        user <- fetch userId
        let originalPasswordHash = user.passwordHash
        let passwordConfirmation = param @Text "passwordConfirmation"
        user
            |> fill @'["email", "passwordHash"]
            |> validateField #passwordHash (isEqual passwordConfirmation |> withCustomErrorMessage "Passwords don't match")
            |> validateField #email isEmail
            |> validateIsUnique #email 
            >>= ifValid \case
                Left user -> render EditView { .. }
                Right user -> do
                    hashed <- 
                      if user.passwordHash == ""
                        then pure originalPasswordHash
                        else hashPassword user.passwordHash
                    user <- user 
                      |> set #passwordHash hashed
                      |> updateRecord
                    setSuccessMessage "User updated"
                    redirectTo EditUserAction { .. }

    action CreateUserAction = do
        let user = newRecord @User
        let passwordConfirmation = param @Text "passwordConfirmation"
        user
            |> fill @'["email", "passwordHash"]
            |> validateField #passwordHash (isEqual passwordConfirmation |> withCustomErrorMessage "Passwords don't match")
            |> validateField #passwordHash nonEmpty
            |> validateField #email isEmail
            |> validateIsUnique #email 
            >>= ifValid \case
                Left user -> render NewView { .. } 
                Right user -> do
                    hashed <- hashPassword user.passwordHash
                    user <- user 
                      |> set #passwordHash hashed
                      |> createRecord
                    setSuccessMessage "User created successfully"
                    redirectTo NewSessionAction

    action DeleteUserAction { userId } = do
        user <- fetch userId
        deleteRecord user
        setSuccessMessage "User deleted"
        redirectTo UsersAction

buildUser user = user
    |> fill @'["email", "passwordHash"]
    
    
    

