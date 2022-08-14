module NonEmptyList exposing (NonEmptyList, fromList, head)


type NonEmptyList a
  = NonEmptyList a (List a)


fromList : a -> List a -> NonEmptyList a
fromList =
  NonEmptyList


head : NonEmptyList a -> a
head (NonEmptyList x _) =
  x
