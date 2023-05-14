module UserMessages
  ERROR400 = "Please specify required params: "
  CREATED = "User created successfully"
  DELETED = "User deleted successfully"
  DUPLICATE = "Id already taken"
  ID_NOT_FOUND = "Could not find user id"
  ERROR500 = "Something went wrong"
end

module AlertMessages
  ERROR400 = "Please specify required params: "
  ERROR500 = "Something went wrong"
  DUPLICATE = "Alert already created"
  CREATED = "Alert created successfully with id: "
  DELETED = "Alert deleted successfully"
  ID_NOT_FOUND = "Could not find user_id or password"
end

module Errors
  DUPLICATE = "UniqueViolation"
  NOT_FOUND = "Couldn't find"
end

module UserStatus
  ACTIVE = "active"
  INACTIVE = "inactive"
  DELETED = "deleted"
end

module AlertStatus
  CREATED = "created"
  TRIGGERED = "triggered"
  DELETED = "deleted"
end

module KEYS
  LIMIT = "limit"
  OFFSET = "offset"
  FILTER = "filter"
end

RequiredParams = {
  "/user/create" => ["id", "name", "email", "password"],
  "/user/delete" => ["id", "password"],
  "/user/token" => ["id", "password"],

  "/alert/create" => ["user_id", "coin", "price", "currency", "password"],
  "/alert/delete" => ["id", "user_id", "password"],
  "/alert/all" => ["user_id", "password"]
}
