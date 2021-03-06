{-# LANGUAGE CPP #-}
#if defined(__GLASGOW_HASKELL__) && __GLASGOW_HASKELL__ >= 704
{-# LANGUAGE Trustworthy #-}
#endif
{-# LANGUAGE Rank2Types #-}

#ifndef MIN_VERSION_template_haskell
#define MIN_VERSION_template_haskell(x,y,z) 1
#endif
-----------------------------------------------------------------------------
-- |
-- Module      :  Language.Haskell.TH.Lens
-- Copyright   :  (C) 2012-2015 Edward Kmett
-- License     :  BSD-style (see the file LICENSE)
-- Maintainer  :  Edward Kmett <ekmett@gmail.com>
-- Stability   :  experimental
-- Portability :  TemplateHaskell
--
-- Lenses, Prisms, and Traversals for working with Template Haskell
----------------------------------------------------------------------------
module Language.Haskell.TH.Lens
  (
  -- * Traversals
    HasName(..)
  , HasTypes(..)
  , HasTypeVars(..)
  , SubstType(..)
  , typeVars      -- :: HasTypeVars t => Traversal' t Name
  , substTypeVars -- :: HasTypeVars t => Map Name Name -> t -> t
  , conFields
  , conNamedFields
  -- * Lenses
  -- ** Loc Lenses
  , locFileName
  , locPackage
  , locModule
  , locStart
  , locEnd
  -- ** FunDep Lenses
  , funDepInputs
  , funDepOutputs
  -- ** Match Lenses
  , matchPattern
  , matchBody
  , matchDeclarations
  -- ** Fixity Lenses
  , fixityPrecedence
  , fixityDirection
  -- ** Clause Lenses
  , clausePattern
  , clauseBody
  , clauseDecs
  -- ** FieldExp Lenses
  , fieldExpName
  , fieldExpExpression
  -- ** FieldPat Lenses
  , fieldPatName
  , fieldPatPattern
#if MIN_VERSION_template_haskell(2,9,0)
  -- ** TySynEqn Lenses
  , tySynEqnPatterns
  , tySynEqnResult
#endif
  -- * Prisms
  -- ** Info Prisms
  , _ClassI
  , _ClassOpI
  , _TyConI
  , _FamilyI
  , _PrimTyConI
  , _DataConI
  , _VarI
  , _TyVarI
  -- ** Dec Prisms
  , _FunD
  , _ValD
  , _DataD
  , _NewtypeD
  , _TySynD
  , _ClassD
  , _InstanceD
  , _SigD
  , _ForeignD
#if MIN_VERSION_template_haskell(2,8,0)
  , _InfixD
#endif
  , _PragmaD
  , _FamilyD
  , _DataInstD
  , _NewtypeInstD
  , _TySynInstD
#if MIN_VERSION_template_haskell(2,9,0)
  , _ClosedTypeFamilyD
  , _RoleAnnotD
#endif
#if MIN_VERSION_template_haskell(2,10,0)
  , _StandaloneDerivD
  , _DefaultSigD
#endif
  -- ** Con Prisms
  , _NormalC
  , _RecC
  , _InfixC
  , _ForallC
  -- ** Strict Prisms
  , _IsStrict
  , _NotStrict
  , _Unpacked
  -- ** Foreign Prisms
  , _ImportF
  , _ExportF
  -- ** Callconv Prisms
  , _CCall
  , _StdCall
#if MIN_VERSION_template_haskell(2,10,0)
  , _CApi
  , _Prim
  , _JavaScript
#endif
  -- ** Safety Prisms
  , _Unsafe
  , _Safe
  , _Interruptible
  -- ** Pragma Prisms
  , _InlineP
  , _SpecialiseP
#if MIN_VERSION_template_haskell(2,8,0)
  , _SpecialiseInstP
  , _RuleP
#if MIN_VERSION_template_haskell(2,9,0)
  , _AnnP
#endif
#if MIN_VERSION_template_haskell(2,10,0)
  , _LineP
#endif
  -- ** Inline Prisms
  , _NoInline
  , _Inline
  , _Inlinable
  -- ** RuleMatch Prisms
  , _ConLike
  , _FunLike
  -- ** Phases Prisms
  , _AllPhases
  , _FromPhase
  , _BeforePhase
  -- ** RuleBndr Prisms
  , _RuleVar
  , _TypedRuleVar
#endif
#if MIN_VERSION_template_haskell(2,9,0)
  -- ** AnnTarget Prisms
  , _ModuleAnnotation
  , _TypeAnnotation
  , _ValueAnnotation
#endif
  -- ** FunDep Prisms TODO make a lens
  , _FunDep
  -- ** FamFlavour Prisms
  , _TypeFam
  , _DataFam
  -- ** FixityDirection Prisms
  , _InfixL
  , _InfixR
  , _InfixN
  -- ** Exp Prisms
  , _VarE
  , _ConE
  , _LitE
  , _AppE
  , _InfixE
  , _UInfixE
  , _ParensE
  , _LamE
#if MIN_VERSION_template_haskell(2,8,0)
  , _LamCaseE
#endif
  , _TupE
  , _UnboxedTupE
  , _CondE
#if MIN_VERSION_template_haskell(2,8,0)
  , _MultiIfE
#endif
  , _LetE
  , _CaseE
  , _DoE
  , _CompE
  , _ArithSeqE
  , _ListE
  , _SigE
  , _RecConE
  , _RecUpdE
#if MIN_VERSION_template_haskell(2,10,0)
  , _StaticE
#endif
  -- ** Body Prisms
  , _GuardedB
  , _NormalB
  -- ** Guard Prisms
  , _NormalG
  , _PatG
  -- ** Stmt Prisms
  , _BindS
  , _LetS
  , _NoBindS
  , _ParS
  -- ** Range Prisms
  , _FromR
  , _FromThenR
  , _FromToR
  , _FromThenToR
  -- ** Lit Prisms
  , _CharL
  , _StringL
  , _IntegerL
  , _RationalL
  , _IntPrimL
  , _WordPrimL
  , _FloatPrimL
  , _DoublePrimL
  , _StringPrimL
  -- ** Pat Prisms
  , _LitP
  , _VarP
  , _TupP
  , _UnboxedTupP
  , _ConP
  , _InfixP
  , _UInfixP
  , _ParensP
  , _TildeP
  , _BangP
  , _AsP
  , _WildP
  , _RecP
  , _ListP
  , _SigP
  , _ViewP
  -- ** Type Prisms
  , _ForallT
  , _AppT
  , _SigT
  , _VarT
  , _ConT
#if MIN_VERSION_template_haskell(2,8,0)
  , _PromotedT
#endif
  , _TupleT
  , _UnboxedTupleT
  , _ArrowT
#if MIN_VERSION_template_haskell(2,10,0)
  , _EqualityT
#endif
  , _ListT
#if MIN_VERSION_template_haskell(2,8,0)
  , _PromotedTupleT
  , _PromotedNilT
  , _PromotedConsT
  , _StarT
  , _ConstraintT
  , _LitT
#endif
  -- ** TyVarBndr Prisms
  , _PlainTV
  , _KindedTV
#if MIN_VERSION_template_haskell(2,8,0)
  -- ** TyLit Prisms
  , _NumTyLit
  , _StrTyLit
#endif
#if !MIN_VERSION_template_haskell(2,10,0)
  -- ** Pred Prisms
  , _ClassP
  , _EqualP
#endif
#if MIN_VERSION_template_haskell(2,9,0)
  -- ** Role Prisms
  , _NominalR
  , _RepresentationalR
  , _PhantomR
  , _InferR
#endif
  ) where

import Control.Applicative
import Control.Lens.At
import Control.Lens.Getter
import Control.Lens.Setter
import Control.Lens.Fold
import Control.Lens.Iso (Iso', iso)
import Control.Lens.Lens
import Control.Lens.Prism
import Control.Lens.Tuple
import Control.Lens.Traversal
import Data.Map as Map hiding (toList,map)
import Data.Maybe (fromMaybe)
import Data.Monoid
import Data.Set as Set hiding (toList,map)
import Data.Set.Lens
import Language.Haskell.TH
import Language.Haskell.TH.Syntax
#if MIN_VERSION_template_haskell(2,8,0)
import Data.Word
#endif
import Prelude

-- | Has a 'Name'
class HasName t where
  -- | Extract (or modify) the 'Name' of something
  name :: Lens' t Name

instance HasName TyVarBndr where
  name f (PlainTV n) = PlainTV <$> f n
  name f (KindedTV n k) = (`KindedTV` k) <$> f n

instance HasName Name where
  name = id

instance HasName Con where
  name f (NormalC n tys)       = (`NormalC` tys) <$> f n
  name f (RecC n tys)          = (`RecC` tys) <$> f n
  name f (InfixC l n r)        = (\n' -> InfixC l n' r) <$> f n
  name f (ForallC bds ctx con) = ForallC bds ctx <$> name f con

-- | Contains some amount of `Type`s inside
class HasTypes t where
  -- | Traverse all the types
  types :: Traversal' t Type

instance HasTypes Type where
  types = id

instance HasTypes Con where
  types f (NormalC n t)      = NormalC n <$> traverse (_2 (types f)) t
  types f (RecC n t)         = RecC n <$> traverse (_3 (types f)) t
  types f (InfixC t1 n t2) = InfixC <$> _2 (types f) t1
                                       <*> pure n <*> _2 (types f) t2
  types f (ForallC vb ctx con)    = ForallC vb ctx <$> types f con

instance HasTypes t => HasTypes [t] where
  types = traverse . types

-- | Provides for the extraction of free type variables, and alpha renaming.
class HasTypeVars t where
  -- | When performing substitution into this traversal you're not allowed
  -- to substitute in a name that is bound internally or you'll violate
  -- the 'Traversal' laws, when in doubt generate your names with 'newName'.
  typeVarsEx :: Set Name -> Traversal' t Name

instance HasTypeVars TyVarBndr where
  typeVarsEx s f b
    | s^.contains (b^.name) = pure b
    | otherwise             = name f b

instance HasTypeVars Name where
  typeVarsEx s f n
    | s^.contains n = pure n
    | otherwise     = f n

instance HasTypeVars Type where
  typeVarsEx s f (VarT n)            = VarT <$> typeVarsEx s f n
  typeVarsEx s f (AppT l r)          = AppT <$> typeVarsEx s f l <*> typeVarsEx s f r
  typeVarsEx s f (SigT t k)          = (`SigT` k) <$> typeVarsEx s f t
  typeVarsEx s f (ForallT bs ctx ty) = ForallT bs <$> typeVarsEx s' f ctx <*> typeVarsEx s' f ty
       where s' = s `Set.union` setOf typeVars bs
  typeVarsEx _ _ t                   = pure t

#if !MIN_VERSION_template_haskell(2,10,0)
instance HasTypeVars Pred where
  typeVarsEx s f (ClassP n ts) = ClassP n <$> typeVarsEx s f ts
  typeVarsEx s f (EqualP l r)  = EqualP <$> typeVarsEx s f l <*> typeVarsEx s f r
#endif

instance HasTypeVars Con where
  typeVarsEx s f (NormalC n ts) = NormalC n <$> traverseOf (traverse . _2) (typeVarsEx s f) ts
  typeVarsEx s f (RecC n ts) = RecC n <$> traverseOf (traverse . _3) (typeVarsEx s f) ts
  typeVarsEx s f (InfixC l n r) = InfixC <$> g l <*> pure n <*> g r
       where g (i, t) = (,) i <$> typeVarsEx s f t
  typeVarsEx s f (ForallC bs ctx c) = ForallC bs <$> typeVarsEx s' f ctx <*> typeVarsEx s' f c
       where s' = s `Set.union` setOf typeVars bs

instance HasTypeVars t => HasTypeVars [t] where
  typeVarsEx s = traverse . typeVarsEx s

instance HasTypeVars t => HasTypeVars (Maybe t) where
  typeVarsEx s = traverse . typeVarsEx s

-- | Traverse /free/ type variables
typeVars :: HasTypeVars t => Traversal' t Name
typeVars = typeVarsEx mempty

-- | Substitute using a map of names in for /free/ type variables
substTypeVars :: HasTypeVars t => Map Name Name -> t -> t
substTypeVars m = over typeVars $ \n -> fromMaybe n (m^.at n)

-- | Provides substitution for types
class SubstType t where
  -- | Perform substitution for types
  substType :: Map Name Type -> t -> t

instance SubstType Type where
  substType m t@(VarT n)          = fromMaybe t (m^.at n)
  substType m (ForallT bs ctx ty) = ForallT bs (substType m' ctx) (substType m' ty)
    where m' = foldrOf typeVars Map.delete m bs
  substType m (SigT t k)          = SigT (substType m t) k
  substType m (AppT l r)          = AppT (substType m l) (substType m r)
  substType _ t                   = t

instance SubstType t => SubstType [t] where
  substType = map . substType

#if !MIN_VERSION_template_haskell(2,10,0)
instance SubstType Pred where
  substType m (ClassP n ts) = ClassP n (substType m ts)
  substType m (EqualP l r)  = substType m (EqualP l r)
#endif

-- | Provides a 'Traversal' of the types of each field of a constructor.
conFields :: Traversal' Con StrictType
conFields f (NormalC n fs)      = NormalC n <$> traverse f fs
conFields f (RecC n fs)         = RecC n <$> traverse sans_var fs
  where sans_var (fn,s,t) = (\(s', t') -> (fn,s',t')) <$> f (s, t)
conFields f (InfixC l n r)      = InfixC <$> f l <*> pure n <*> f r
conFields f (ForallC bds ctx c) = ForallC bds ctx <$> conFields f c

-- | 'Traversal' of the types of the /named/ fields of a constructor.
conNamedFields :: Traversal' Con VarStrictType
conNamedFields f (RecC n fs) = RecC n <$> traverse f fs
conNamedFields f (ForallC a b fs) = ForallC a b <$> conNamedFields f fs
conNamedFields _ c = pure c

-- Lenses and Prisms
locFileName :: Lens' Loc String
locFileName = lens loc_filename
            $ \loc fn -> loc { loc_filename = fn }

locPackage :: Lens' Loc String
locPackage = lens loc_package
           $ \loc fn -> loc { loc_package = fn }

locModule :: Lens' Loc String
locModule = lens loc_module
          $ \loc fn -> loc { loc_module = fn }

locStart :: Lens' Loc CharPos
locStart = lens loc_start
         $ \loc fn -> loc { loc_start = fn }

locEnd :: Lens' Loc CharPos
locEnd = lens loc_end
       $ \loc fn -> loc { loc_end = fn }

funDepInputs :: Lens' FunDep [Name]
funDepInputs = lens g s where
   g (FunDep xs _)    = xs
   s (FunDep _ ys) xs = FunDep xs ys

funDepOutputs :: Lens' FunDep [Name]
funDepOutputs = lens g s where
   g (FunDep _ xs) = xs
   s (FunDep ys _) = FunDep ys

fieldExpName :: Lens' FieldExp Name
fieldExpName = _1

fieldExpExpression :: Lens' FieldExp Exp
fieldExpExpression = _2

fieldPatName :: Lens' FieldPat Name
fieldPatName = _1

fieldPatPattern :: Lens' FieldPat Pat
fieldPatPattern = _2

matchPattern :: Lens' Match Pat
matchPattern = lens g s where
   g (Match p _ _)   = p
   s (Match _ x y) p = Match p x y

matchBody :: Lens' Match Body
matchBody = lens g s where
   g (Match _ b _)   = b
   s (Match x _ y) b = Match x b y

matchDeclarations :: Lens' Match [Dec]
matchDeclarations = lens g s where
   g (Match _ _ ds) = ds
   s (Match x y _ ) = Match x y

fixityPrecedence :: Lens' Fixity Int
fixityPrecedence = lens g s where
   g (Fixity i _)   = i
   s (Fixity _ x) i = Fixity i x

fixityDirection :: Lens' Fixity FixityDirection
fixityDirection = lens g s where
   g (Fixity _ d) = d
   s (Fixity i _) = Fixity i

clausePattern :: Lens' Clause [Pat]
clausePattern = lens g s where
   g (Clause ps _ _)    = ps
   s (Clause _  x y) ps = Clause ps x y

clauseBody :: Lens' Clause Body
clauseBody = lens g s where
   g (Clause _ b _)   = b
   s (Clause x _ y) b = Clause x b y

clauseDecs :: Lens' Clause [Dec]
clauseDecs = lens g s where
   g (Clause _ _ ds) = ds
   s (Clause x y _ ) = Clause x y

#if MIN_VERSION_template_haskell(2,8,0)
_ClassI :: Prism' Info (Dec, [InstanceDec])
_ClassI
  = prism' reviewer remitter
  where
      reviewer (x, y) = ClassI x y
      remitter (ClassI x y) = Just (x, y)
      remitter _ = Nothing

_ClassOpI :: Prism' Info (Name, Type, ParentName, Fixity)
_ClassOpI
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w) = ClassOpI x y z w
      remitter (ClassOpI x y z w) = Just (x, y, z, w)
      remitter _ = Nothing

#else
_ClassI :: Prism' Info (Dec, [Dec])
_ClassI
  = prism' reviewer remitter
  where
      reviewer (x, y) = ClassI x y
      remitter (ClassI x y) = Just (x, y)
      remitter _ = Nothing

_ClassOpI :: Prism' Info (Name, Type, Name, Fixity)
_ClassOpI
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w) = ClassOpI x y z w
      remitter (ClassOpI x y z w) = Just (x, y, z, w)
      remitter _ = Nothing
#endif

_TyConI :: Prism' Info Dec
_TyConI
  = prism' reviewer remitter
  where
      reviewer = TyConI
      remitter (TyConI x) = Just x
      remitter _ = Nothing

#if MIN_VERSION_template_haskell(2,8,0)
_FamilyI :: Prism' Info (Dec, [InstanceDec])
_FamilyI
  = prism' reviewer remitter
  where
      reviewer (x, y) = FamilyI x y
      remitter (FamilyI x y) = Just (x, y)
      remitter _ = Nothing

_PrimTyConI :: Prism' Info (Name, Arity, Unlifted)
_PrimTyConI
  = prism' reviewer remitter
  where
      reviewer (x, y, z) = PrimTyConI x y z
      remitter (PrimTyConI x y z) = Just (x, y, z)
      remitter _ = Nothing

_DataConI :: Prism' Info (Name, Type, ParentName, Fixity)
_DataConI
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w) = DataConI x y z w
      remitter (DataConI x y z w) = Just (x, y, z, w)
      remitter _ = Nothing
#else
_FamilyI :: Prism' Info (Dec, [Dec])
_FamilyI
  = prism' reviewer remitter
  where
      reviewer (x, y) = FamilyI x y
      remitter (FamilyI x y) = Just (x, y)
      remitter _ = Nothing

_PrimTyConI :: Prism' Info (Name, Int, Bool)
_PrimTyConI
  = prism' reviewer remitter
  where
      reviewer (x, y, z) = PrimTyConI x y z
      remitter (PrimTyConI x y z) = Just (x, y, z)
      remitter _ = Nothing

_DataConI :: Prism' Info (Name, Type, Name, Fixity)
_DataConI
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w) = DataConI x y z w
      remitter (DataConI x y z w) = Just (x, y, z, w)
      remitter _ = Nothing

#endif

_VarI :: Prism' Info (Name, Type, Maybe Dec, Fixity)
_VarI
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w) = VarI x y z w
      remitter (VarI x y z w) = Just (x, y, z, w)
      remitter _ = Nothing

_TyVarI :: Prism' Info (Name, Type)
_TyVarI
  = prism' reviewer remitter
  where
      reviewer (x, y) = TyVarI x y
      remitter (TyVarI x y) = Just (x, y)
      remitter _ = Nothing

_FunD :: Prism' Dec (Name, [Clause])
_FunD
  = prism' reviewer remitter
  where
      reviewer (x, y) = FunD x y
      remitter (FunD x y) = Just (x,y)
      remitter _ = Nothing

_ValD :: Prism' Dec (Pat, Body, [Dec])
_ValD
  = prism' reviewer remitter
  where
      reviewer (x, y, z) = ValD x y z
      remitter (ValD x y z) = Just (x, y, z)
      remitter _ = Nothing

_DataD :: Prism' Dec (Cxt, Name, [TyVarBndr], [Con], [Name])
_DataD
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w, u) = DataD x y z w u
      remitter (DataD x y z w u) = Just (x, y, z, w, u)
      remitter _ = Nothing

_NewtypeD :: Prism' Dec (Cxt, Name, [TyVarBndr], Con, [Name])
_NewtypeD
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w, u) = NewtypeD x y z w u
      remitter (NewtypeD x y z w u) = Just (x, y, z, w, u)
      remitter _ = Nothing

_TySynD :: Prism' Dec (Name, [TyVarBndr], Type)
_TySynD
  = prism' reviewer remitter
  where
      reviewer (x, y, z) = TySynD x y z
      remitter (TySynD x y z) = Just (x, y, z)
      remitter _ = Nothing

_ClassD :: Prism' Dec (Cxt, Name, [TyVarBndr], [FunDep], [Dec])
_ClassD
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w, u) = ClassD x y z w u
      remitter (ClassD x y z w u) = Just (x, y, z, w, u)
      remitter _ = Nothing

_InstanceD :: Prism' Dec (Cxt, Type, [Dec])
_InstanceD
  = prism' reviewer remitter
  where
      reviewer (x, y, z) = InstanceD x y z
      remitter (InstanceD x y z) = Just (x, y, z)
      remitter _ = Nothing

_SigD :: Prism' Dec (Name, Type)
_SigD
  = prism' reviewer remitter
  where
      reviewer (x, y) = SigD x y
      remitter (SigD x y) = Just (x, y)
      remitter _ = Nothing

_ForeignD :: Prism' Dec Foreign
_ForeignD
  = prism' reviewer remitter
  where
      reviewer = ForeignD
      remitter (ForeignD x) = Just x
      remitter _ = Nothing

#if MIN_VERSION_template_haskell(2,8,0)
_InfixD :: Prism' Dec (Fixity, Name)
_InfixD
  = prism' reviewer remitter
  where
      reviewer (x, y) = InfixD x y
      remitter (InfixD x y) = Just (x, y)
      remitter _ = Nothing
#endif

_PragmaD :: Prism' Dec Pragma
_PragmaD
  = prism' reviewer remitter
  where
      reviewer = PragmaD
      remitter (PragmaD x) = Just x
      remitter _ = Nothing

_FamilyD :: Prism' Dec (FamFlavour, Name, [TyVarBndr], Maybe Kind)
_FamilyD
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w) = FamilyD x y z w
      remitter (FamilyD x y z w) = Just (x, y, z, w)
      remitter _ = Nothing

_DataInstD :: Prism' Dec (Cxt, Name, [Type], [Con], [Name])
_DataInstD
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w, u) = DataInstD x y z w u
      remitter (DataInstD x y z w u) = Just (x, y, z, w, u)
      remitter _ = Nothing

_NewtypeInstD :: Prism' Dec (Cxt, Name, [Type], Con, [Name])
_NewtypeInstD
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w, u) = NewtypeInstD x y z w u
      remitter (NewtypeInstD x y z w u) = Just (x, y, z, w, u)
      remitter _ = Nothing

#if MIN_VERSION_template_haskell(2,9,0)
_TySynInstD :: Prism' Dec (Name, TySynEqn)
_TySynInstD
  = prism' reviewer remitter
  where
      reviewer (x, y) = TySynInstD x y
      remitter (TySynInstD x y) = Just (x, y)
      remitter _ = Nothing

_ClosedTypeFamilyD :: Prism' Dec (Name, [TyVarBndr], Maybe Kind, [TySynEqn])
_ClosedTypeFamilyD
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w) = ClosedTypeFamilyD x y z w
      remitter (ClosedTypeFamilyD x y z w) = Just (x, y, z, w)
      remitter _ = Nothing

_RoleAnnotD :: Prism' Dec (Name, [Role])
_RoleAnnotD
  = prism' reviewer remitter
  where
      reviewer (x, y) = RoleAnnotD x y
      remitter (RoleAnnotD x y) = Just (x, y)
      remitter _ = Nothing

#else
_TySynInstD :: Prism' Dec (Name, [Type], Type)
_TySynInstD
  = prism' reviewer remitter
  where
      reviewer (x, y, z) = TySynInstD x y z
      remitter (TySynInstD x y z) = Just (x, y, z)
      remitter _ = Nothing
#endif

#if MIN_VERSION_template_haskell(2,10,0)
_StandaloneDerivD :: Prism' Dec (Cxt, Type)
_StandaloneDerivD
  = prism' reviewer remitter
  where
      reviewer (x, y) = StandaloneDerivD x y
      remitter (StandaloneDerivD x y) = Just (x, y)
      remitter _ = Nothing

_DefaultSigD :: Prism' Dec (Name, Type)
_DefaultSigD
  = prism' reviewer remitter
  where
      reviewer (x, y) = DefaultSigD x y
      remitter (DefaultSigD x y) = Just (x, y)
      remitter _ = Nothing
#endif

_NormalC ::
  Prism' Con (Name, [StrictType])
_NormalC
  = prism' reviewer remitter
  where
      reviewer (x, y) = NormalC x y
      remitter (NormalC x y) = Just (x, y)
      remitter _ = Nothing

_RecC ::
  Prism' Con (Name, [VarStrictType])
_RecC
  = prism' reviewer remitter
  where
      reviewer (x, y) = RecC x y
      remitter (RecC x y) = Just (x, y)
      remitter _ = Nothing

_InfixC ::
  Prism' Con (StrictType,
              Name,
              StrictType)
_InfixC
  = prism' reviewer remitter
  where
      reviewer (x, y, z) = InfixC x y z
      remitter (InfixC x y z) = Just (x, y, z)
      remitter _ = Nothing

_ForallC :: Prism' Con ([TyVarBndr], Cxt, Con)
_ForallC
  = prism' reviewer remitter
  where
      reviewer (x, y, z) = ForallC x y z
      remitter (ForallC x y z) = Just (x, y, z)
      remitter _ = Nothing

_IsStrict :: Prism' Strict ()
_IsStrict
  = prism' reviewer remitter
  where
      reviewer () = IsStrict
      remitter IsStrict = Just ()
      remitter _ = Nothing

_NotStrict :: Prism' Strict ()
_NotStrict
  = prism' reviewer remitter
  where
      reviewer () = NotStrict
      remitter NotStrict = Just ()
      remitter _ = Nothing

_Unpacked :: Prism' Strict ()
_Unpacked
  = prism' reviewer remitter
  where
      reviewer () = Unpacked
      remitter Unpacked = Just ()
      remitter _ = Nothing

_ImportF :: Prism' Foreign (Callconv, Safety, String, Name, Type)
_ImportF
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w, u) = ImportF x y z w u
      remitter (ImportF x y z w u) = Just (x,y,z,w,u)
      remitter _ = Nothing

_ExportF :: Prism' Foreign (Callconv, String, Name, Type)
_ExportF
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w) = ExportF x y z w
      remitter (ExportF x y z w) = Just (x, y, z, w)
      remitter _ = Nothing

_CCall :: Prism' Callconv ()
_CCall
  = prism' reviewer remitter
  where
      reviewer () = CCall
      remitter CCall = Just ()
      remitter _ = Nothing

_StdCall :: Prism' Callconv ()
_StdCall
  = prism' reviewer remitter
  where
      reviewer () = StdCall
      remitter StdCall = Just ()
      remitter _ = Nothing

#if MIN_VERSION_template_haskell(2,10,0)
_CApi :: Prism' Callconv ()
_CApi
  = prism' reviewer remitter
  where
      reviewer () = CApi
      remitter CApi = Just ()
      remitter _ = Nothing

_Prim :: Prism' Callconv ()
_Prim
  = prism' reviewer remitter
  where
      reviewer () = Prim
      remitter Prim = Just ()
      remitter _ = Nothing

_JavaScript :: Prism' Callconv ()
_JavaScript
  = prism' reviewer remitter
  where
      reviewer () = JavaScript
      remitter JavaScript = Just ()
      remitter _ = Nothing
#endif

_Unsafe :: Prism' Safety ()
_Unsafe
  = prism' reviewer remitter
  where
      reviewer () = Unsafe
      remitter Unsafe = Just ()
      remitter _ = Nothing

_Safe :: Prism' Safety ()
_Safe
  = prism' reviewer remitter
  where
      reviewer () = Safe
      remitter Safe = Just ()
      remitter _ = Nothing

_Interruptible :: Prism' Safety ()
_Interruptible
  = prism' reviewer remitter
  where
      reviewer () = Interruptible
      remitter Interruptible = Just ()
      remitter _ = Nothing

#if MIN_VERSION_template_haskell(2,8,0)
_InlineP :: Prism' Pragma (Name, Inline, RuleMatch, Phases)
_InlineP
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w) = InlineP x y z w
      remitter (InlineP x y z w) = Just (x, y, z, w)
      remitter _ = Nothing

_SpecialiseP :: Prism' Pragma (Name, Type, Maybe Inline, Phases)
_SpecialiseP
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w) = SpecialiseP x y z w
      remitter (SpecialiseP x y z w) = Just (x, y, z, w)
      remitter _ = Nothing
#else
_InlineP :: Prism' Pragma (Name, InlineSpec)
_InlineP
  = prism' reviewer remitter
  where
      reviewer (x, y) = InlineP x y
      remitter (InlineP x y) = Just (x, y)
      remitter _ = Nothing

_SpecialiseP :: Prism' Pragma (Name, Type, Maybe InlineSpec)
_SpecialiseP
  = prism' reviewer remitter
  where
      reviewer (x, y, z) = SpecialiseP x y z
      remitter (SpecialiseP x y z) = Just (x, y, z)
      remitter _ = Nothing

-- TODO add lenses for InlineSpec
#endif

#if MIN_VERSION_template_haskell(2,8,0)
_SpecialiseInstP :: Prism' Pragma Type
_SpecialiseInstP
  = prism' reviewer remitter
  where
      reviewer = SpecialiseInstP
      remitter (SpecialiseInstP x) = Just x
      remitter _ = Nothing

_RuleP :: Prism' Pragma (String, [RuleBndr], Exp, Exp, Phases)
_RuleP
  = prism' reviewer remitter
  where
      reviewer (x, y, z, w, u) = RuleP x y z w u
      remitter (RuleP x y z w u) = Just (x, y, z, w, u)
      remitter _ = Nothing

#if MIN_VERSION_template_haskell(2,9,0)
_AnnP :: Prism' Pragma (AnnTarget, Exp)
_AnnP
  = prism' reviewer remitter
  where
      reviewer (x, y) = AnnP x y
      remitter (AnnP x y) = Just (x, y)
      remitter _ = Nothing
#endif

#if MIN_VERSION_template_haskell(2,10,0)
_LineP :: Prism' Pragma (Int, String)
_LineP
  = prism' reviewer remitter
  where
      reviewer (x, y) = LineP x y
      remitter (LineP x y) = Just (x, y)
      remitter _ = Nothing
#endif

_NoInline :: Prism' Inline ()
_NoInline
  = prism' reviewer remitter
  where
      reviewer () = NoInline
      remitter NoInline = Just ()
      remitter _ = Nothing

_Inline :: Prism' Inline ()
_Inline
  = prism' reviewer remitter
  where
      reviewer () = Inline
      remitter Inline = Just ()
      remitter _ = Nothing

_Inlinable :: Prism' Inline ()
_Inlinable
  = prism' reviewer remitter
  where
      reviewer () = Inlinable
      remitter Inlinable = Just ()
      remitter _ = Nothing

_ConLike :: Prism' RuleMatch ()
_ConLike
  = prism' reviewer remitter
  where
      reviewer () = ConLike
      remitter ConLike = Just ()
      remitter _ = Nothing

_FunLike :: Prism' RuleMatch ()
_FunLike
  = prism' reviewer remitter
  where
      reviewer () = FunLike
      remitter FunLike = Just ()
      remitter _ = Nothing

_AllPhases :: Prism' Phases ()
_AllPhases
  = prism' reviewer remitter
  where
      reviewer () = AllPhases
      remitter AllPhases = Just ()
      remitter _ = Nothing

_FromPhase :: Prism' Phases Int
_FromPhase
  = prism' reviewer remitter
  where
      reviewer = FromPhase
      remitter (FromPhase x) = Just x
      remitter _ = Nothing

_BeforePhase :: Prism' Phases Int
_BeforePhase
  = prism' reviewer remitter
  where
      reviewer = BeforePhase
      remitter (BeforePhase x) = Just x
      remitter _ = Nothing

_RuleVar :: Prism' RuleBndr Name
_RuleVar
  = prism' reviewer remitter
  where
      reviewer = RuleVar
      remitter (RuleVar x) = Just x
      remitter _ = Nothing

_TypedRuleVar :: Prism' RuleBndr (Name, Type)
_TypedRuleVar
  = prism' reviewer remitter
  where
      reviewer (x, y) = TypedRuleVar x y
      remitter (TypedRuleVar x y) = Just (x, y)
      remitter _ = Nothing
#endif

#if MIN_VERSION_template_haskell(2,9,0)
_ModuleAnnotation :: Prism' AnnTarget ()
_ModuleAnnotation
  = prism' reviewer remitter
  where
      reviewer () = ModuleAnnotation
      remitter ModuleAnnotation = Just ()
      remitter _ = Nothing

_TypeAnnotation :: Prism' AnnTarget Name
_TypeAnnotation
  = prism' reviewer remitter
  where
      reviewer = TypeAnnotation
      remitter (TypeAnnotation x) = Just x
      remitter _ = Nothing

_ValueAnnotation :: Prism' AnnTarget Name
_ValueAnnotation
  = prism' reviewer remitter
  where
      reviewer = ValueAnnotation
      remitter (ValueAnnotation x) = Just x
      remitter _ = Nothing
#endif

_FunDep :: Iso' FunDep ([Name], [Name])
_FunDep
  = iso remitter reviewer
  where
      reviewer (x, y) = FunDep x y
      remitter (FunDep x y) = (x, y)

_TypeFam :: Prism' FamFlavour ()
_TypeFam
  = prism' reviewer remitter
  where
      reviewer () = TypeFam
      remitter TypeFam = Just ()
      remitter _ = Nothing

_DataFam :: Prism' FamFlavour ()
_DataFam
  = prism' reviewer remitter
  where
      reviewer () = DataFam
      remitter DataFam = Just ()
      remitter _ = Nothing

#if MIN_VERSION_template_haskell(2,9,0)
tySynEqnPatterns :: Lens' TySynEqn [Type]
tySynEqnPatterns = lens g s where
   g (TySynEqn xs _)    = xs
   s (TySynEqn _  y) xs = TySynEqn xs y

tySynEqnResult :: Lens' TySynEqn Type
tySynEqnResult = lens g s where
   g (TySynEqn _  x) = x
   s (TySynEqn xs _) = TySynEqn xs
#endif

_InfixL :: Prism' FixityDirection ()
_InfixL
  = prism' reviewer remitter
  where
      reviewer () = InfixL
      remitter InfixL = Just ()
      remitter _ = Nothing

_InfixR :: Prism' FixityDirection ()
_InfixR
  = prism' reviewer remitter
  where
      reviewer () = InfixR
      remitter InfixR = Just ()
      remitter _ = Nothing

_InfixN :: Prism' FixityDirection ()
_InfixN
  = prism' reviewer remitter
  where
      reviewer () = InfixN
      remitter InfixN = Just ()
      remitter _ = Nothing

_VarE :: Prism' Exp Name
_VarE
  = prism' reviewer remitter
  where
      reviewer = VarE
      remitter (VarE x) = Just x
      remitter _ = Nothing

_ConE :: Prism' Exp Name
_ConE
  = prism' reviewer remitter
  where
      reviewer = ConE
      remitter (ConE x) = Just x
      remitter _ = Nothing

_LitE :: Prism' Exp Lit
_LitE
  = prism' reviewer remitter
  where
      reviewer = LitE
      remitter (LitE x) = Just x
      remitter _ = Nothing

_AppE :: Prism' Exp (Exp, Exp)
_AppE
  = prism' reviewer remitter
  where
      reviewer (x, y) = AppE x y
      remitter (AppE x y) = Just (x, y)
      remitter _ = Nothing

_InfixE :: Prism' Exp (Maybe Exp, Exp, Maybe Exp)
_InfixE
  = prism' reviewer remitter
  where
      reviewer (x, y, z) = InfixE x y z
      remitter (InfixE x y z) = Just (x, y, z)
      remitter _ = Nothing

_UInfixE :: Prism' Exp (Exp, Exp, Exp)
_UInfixE
  = prism' reviewer remitter
  where
      reviewer (x, y, z) = UInfixE x y z
      remitter (UInfixE x y z) = Just (x, y, z)
      remitter _ = Nothing

_ParensE :: Prism' Exp Exp
_ParensE
  = prism' reviewer remitter
  where
      reviewer = ParensE
      remitter (ParensE x) = Just x
      remitter _ = Nothing

_LamE :: Prism' Exp ([Pat], Exp)
_LamE
  = prism' reviewer remitter
  where
      reviewer (x, y) = LamE x y
      remitter (LamE x y) = Just (x, y)
      remitter _ = Nothing

#if MIN_VERSION_template_haskell(2,8,0)
_LamCaseE :: Prism' Exp [Match]
_LamCaseE
  = prism' reviewer remitter
  where
      reviewer = LamCaseE
      remitter (LamCaseE x) = Just x
      remitter _ = Nothing
#endif

_TupE :: Prism' Exp [Exp]
_TupE
  = prism' reviewer remitter
  where
      reviewer = TupE
      remitter (TupE x) = Just x
      remitter _ = Nothing

_UnboxedTupE :: Prism' Exp [Exp]
_UnboxedTupE
  = prism' reviewer remitter
  where
      reviewer = UnboxedTupE
      remitter (UnboxedTupE x) = Just x
      remitter _ = Nothing

_CondE :: Prism' Exp (Exp, Exp, Exp)
_CondE
  = prism' reviewer remitter
  where
      reviewer (x, y, z) = CondE x y z
      remitter (CondE x y z) = Just (x, y, z)
      remitter _ = Nothing

#if MIN_VERSION_template_haskell(2,8,0)
_MultiIfE :: Prism' Exp [(Guard, Exp)]
_MultiIfE
  = prism' reviewer remitter
  where
      reviewer = MultiIfE
      remitter (MultiIfE x) = Just x
      remitter _ = Nothing
#endif

_LetE :: Prism' Exp ([Dec], Exp)
_LetE
  = prism' reviewer remitter
  where
      reviewer (x, y) = LetE x y
      remitter (LetE x y) = Just (x, y)
      remitter _ = Nothing

_CaseE :: Prism' Exp (Exp, [Match])
_CaseE
  = prism' reviewer remitter
  where
      reviewer (x, y) = CaseE x y
      remitter (CaseE x y) = Just (x, y)
      remitter _ = Nothing

_DoE :: Prism' Exp [Stmt]
_DoE
  = prism' reviewer remitter
  where
      reviewer = DoE
      remitter (DoE x) = Just x
      remitter _ = Nothing

_CompE :: Prism' Exp [Stmt]
_CompE
  = prism' reviewer remitter
  where
      reviewer = CompE
      remitter (CompE x) = Just x
      remitter _ = Nothing

_ArithSeqE :: Prism' Exp Range
_ArithSeqE
  = prism' reviewer remitter
  where
      reviewer = ArithSeqE
      remitter (ArithSeqE x) = Just x
      remitter _ = Nothing

_ListE :: Prism' Exp [Exp]
_ListE
  = prism' reviewer remitter
  where
      reviewer = ListE
      remitter (ListE x) = Just x
      remitter _ = Nothing

_SigE :: Prism' Exp (Exp, Type)
_SigE
  = prism' reviewer remitter
  where
      reviewer (x, y) = SigE x y
      remitter (SigE x y) = Just (x, y)
      remitter _ = Nothing

_RecConE :: Prism' Exp (Name, [FieldExp])
_RecConE
  = prism' reviewer remitter
  where
      reviewer (x, y) = RecConE x y
      remitter (RecConE x y) = Just (x, y)
      remitter _ = Nothing

_RecUpdE :: Prism' Exp (Exp, [FieldExp])
_RecUpdE
  = prism' reviewer remitter
  where
      reviewer (x, y) = RecUpdE x y
      remitter (RecUpdE x y) = Just (x, y)
      remitter _ = Nothing

#if MIN_VERSION_template_haskell(2,10,0)
_StaticE :: Prism' Exp Exp
_StaticE
  = prism' reviewer remitter
  where
      reviewer = StaticE
      remitter (StaticE x) = Just x
      remitter _ = Nothing
#endif

_GuardedB :: Prism' Body [(Guard, Exp)]
_GuardedB
  = prism' reviewer remitter
  where
      reviewer = GuardedB
      remitter (GuardedB x) = Just x
      remitter _ = Nothing

_NormalB :: Prism' Body Exp
_NormalB
  = prism' reviewer remitter
  where
      reviewer = NormalB
      remitter (NormalB x) = Just x
      remitter _ = Nothing

_NormalG :: Prism' Guard Exp
_NormalG
  = prism' reviewer remitter
  where
      reviewer = NormalG
      remitter (NormalG x) = Just x
      remitter _ = Nothing

_PatG :: Prism' Guard [Stmt]
_PatG
  = prism' reviewer remitter
  where
      reviewer = PatG
      remitter (PatG x) = Just x
      remitter _ = Nothing

_BindS :: Prism' Stmt (Pat, Exp)
_BindS
  = prism' reviewer remitter
  where
      reviewer (x, y) = BindS x y
      remitter (BindS x y) = Just (x, y)
      remitter _ = Nothing

_LetS :: Prism' Stmt [Dec]
_LetS
  = prism' reviewer remitter
  where
      reviewer = LetS
      remitter (LetS x) = Just x
      remitter _ = Nothing

_NoBindS :: Prism' Stmt Exp
_NoBindS
  = prism' reviewer remitter
  where
      reviewer = NoBindS
      remitter (NoBindS x) = Just x
      remitter _ = Nothing

_ParS :: Prism' Stmt [[Stmt]]
_ParS
  = prism' reviewer remitter
  where
      reviewer = ParS
      remitter (ParS x) = Just x
      remitter _ = Nothing

_FromR :: Prism' Range Exp
_FromR
  = prism' reviewer remitter
  where
      reviewer = FromR
      remitter (FromR x) = Just x
      remitter _ = Nothing

_FromThenR :: Prism' Range (Exp, Exp)
_FromThenR
  = prism' reviewer remitter
  where
      reviewer (x, y) = FromThenR x y
      remitter (FromThenR x y) = Just (x, y)
      remitter _ = Nothing

_FromToR :: Prism' Range (Exp, Exp)
_FromToR
  = prism' reviewer remitter
  where
      reviewer (x, y) = FromToR x y
      remitter (FromToR x y) = Just (x, y)
      remitter _ = Nothing

_FromThenToR :: Prism' Range (Exp, Exp, Exp)
_FromThenToR
  = prism' reviewer remitter
  where
      reviewer (x, y, z) = FromThenToR x y z
      remitter (FromThenToR x y z) = Just (x, y, z)
      remitter _ = Nothing

_CharL :: Prism' Lit Char
_CharL
  = prism' reviewer remitter
  where
      reviewer = CharL
      remitter (CharL x) = Just x
      remitter _ = Nothing

_StringL :: Prism' Lit String
_StringL
  = prism' reviewer remitter
  where
      reviewer = StringL
      remitter (StringL x) = Just x
      remitter _ = Nothing

_IntegerL :: Prism' Lit Integer
_IntegerL
  = prism' reviewer remitter
  where
      reviewer = IntegerL
      remitter (IntegerL x) = Just x
      remitter _ = Nothing

_RationalL :: Prism' Lit Rational
_RationalL
  = prism' reviewer remitter
  where
      reviewer = RationalL
      remitter (RationalL x) = Just x
      remitter _ = Nothing

_IntPrimL :: Prism' Lit Integer
_IntPrimL
  = prism' reviewer remitter
  where
      reviewer = IntPrimL
      remitter (IntPrimL x) = Just x
      remitter _ = Nothing

_WordPrimL :: Prism' Lit Integer
_WordPrimL
  = prism' reviewer remitter
  where
      reviewer = WordPrimL
      remitter (WordPrimL x) = Just x
      remitter _ = Nothing

_FloatPrimL :: Prism' Lit Rational
_FloatPrimL
  = prism' reviewer remitter
  where
      reviewer = FloatPrimL
      remitter (FloatPrimL x) = Just x
      remitter _ = Nothing

_DoublePrimL :: Prism' Lit Rational
_DoublePrimL
  = prism' reviewer remitter
  where
      reviewer = DoublePrimL
      remitter (DoublePrimL x) = Just x
      remitter _ = Nothing

#if MIN_VERSION_template_haskell(2,8,0)
_StringPrimL :: Prism' Lit [Word8]
_StringPrimL
  = prism' reviewer remitter
  where
      reviewer = StringPrimL
      remitter (StringPrimL x) = Just x
      remitter _ = Nothing
#else
_StringPrimL :: Prism' Lit String
_StringPrimL
  = prism' reviewer remitter
  where
      reviewer = StringPrimL
      remitter (StringPrimL x) = Just x
      remitter _ = Nothing
#endif

_LitP :: Prism' Pat Lit
_LitP
  = prism' reviewer remitter
  where
      reviewer = LitP
      remitter (LitP x) = Just x
      remitter _ = Nothing

_VarP :: Prism' Pat Name
_VarP
  = prism' reviewer remitter
  where
      reviewer = VarP
      remitter (VarP x) = Just x
      remitter _ = Nothing

_TupP :: Prism' Pat [Pat]
_TupP
  = prism' reviewer remitter
  where
      reviewer = TupP
      remitter (TupP x) = Just x
      remitter _ = Nothing

_UnboxedTupP :: Prism' Pat [Pat]
_UnboxedTupP
  = prism' reviewer remitter
  where
      reviewer = UnboxedTupP
      remitter (UnboxedTupP x) = Just x
      remitter _ = Nothing

_ConP :: Prism' Pat (Name, [Pat])
_ConP
  = prism' reviewer remitter
  where
      reviewer (x, y) = ConP x y
      remitter (ConP x y) = Just (x, y)
      remitter _ = Nothing

_InfixP :: Prism' Pat (Pat, Name, Pat)
_InfixP
  = prism' reviewer remitter
  where
      reviewer (x, y, z) = InfixP x y z
      remitter (InfixP x y z) = Just (x, y, z)
      remitter _ = Nothing

_UInfixP :: Prism' Pat (Pat, Name, Pat)
_UInfixP
  = prism' reviewer remitter
  where
      reviewer (x, y, z) = UInfixP x y z
      remitter (UInfixP x y z) = Just (x, y, z)
      remitter _ = Nothing

_ParensP :: Prism' Pat Pat
_ParensP
  = prism' reviewer remitter
  where
      reviewer = ParensP
      remitter (ParensP x) = Just x
      remitter _ = Nothing

_TildeP :: Prism' Pat Pat
_TildeP
  = prism' reviewer remitter
  where
      reviewer = TildeP
      remitter (TildeP x) = Just x
      remitter _ = Nothing

_BangP :: Prism' Pat Pat
_BangP
  = prism' reviewer remitter
  where
      reviewer = BangP
      remitter (BangP x) = Just x
      remitter _ = Nothing

_AsP :: Prism' Pat (Name, Pat)
_AsP
  = prism' reviewer remitter
  where
      reviewer (x, y) = AsP x y
      remitter (AsP x y) = Just (x, y)
      remitter _ = Nothing

_WildP :: Prism' Pat ()
_WildP
  = prism' reviewer remitter
  where
      reviewer () = WildP
      remitter WildP = Just ()
      remitter _ = Nothing

_RecP :: Prism' Pat (Name, [FieldPat])
_RecP
  = prism' reviewer remitter
  where
      reviewer (x, y) = RecP x y
      remitter (RecP x y) = Just (x, y)
      remitter _ = Nothing

_ListP :: Prism' Pat [Pat]
_ListP
  = prism' reviewer remitter
  where
      reviewer = ListP
      remitter (ListP x) = Just x
      remitter _ = Nothing

_SigP :: Prism' Pat (Pat, Type)
_SigP
  = prism' reviewer remitter
  where
      reviewer (x, y) = SigP x y
      remitter (SigP x y) = Just (x, y)
      remitter _ = Nothing

_ViewP :: Prism' Pat (Exp, Pat)
_ViewP
  = prism' reviewer remitter
  where
      reviewer (x, y) = ViewP x y
      remitter (ViewP x y) = Just (x, y)
      remitter _ = Nothing

_ForallT :: Prism' Type ([TyVarBndr], Cxt, Type)
_ForallT
  = prism' reviewer remitter
  where
      reviewer (x, y, z) = ForallT x y z
      remitter (ForallT x y z) = Just (x, y, z)
      remitter _ = Nothing

_AppT :: Prism' Type (Type, Type)
_AppT
  = prism' reviewer remitter
  where
      reviewer (x, y) = AppT x y
      remitter (AppT x y) = Just (x, y)
      remitter _ = Nothing

_SigT :: Prism' Type (Type, Kind)
_SigT
  = prism' reviewer remitter
  where
      reviewer (x, y) = SigT x y
      remitter (SigT x y) = Just (x, y)
      remitter _ = Nothing

_VarT :: Prism' Type Name
_VarT
  = prism' reviewer remitter
  where
      reviewer = VarT
      remitter (VarT x) = Just x
      remitter _ = Nothing

_ConT :: Prism' Type Name
_ConT
  = prism' reviewer remitter
  where
      reviewer = ConT
      remitter (ConT x) = Just x
      remitter _ = Nothing

#if MIN_VERSION_template_haskell(2,8,0)
_PromotedT :: Prism' Type Name
_PromotedT
  = prism' reviewer remitter
  where
      reviewer = PromotedT
      remitter (PromotedT x) = Just x
      remitter _ = Nothing
#endif

_TupleT :: Prism' Type Int
_TupleT
  = prism' reviewer remitter
  where
      reviewer = TupleT
      remitter (TupleT x) = Just x
      remitter _ = Nothing

_UnboxedTupleT :: Prism' Type Int
_UnboxedTupleT
  = prism' reviewer remitter
  where
      reviewer = UnboxedTupleT
      remitter (UnboxedTupleT x) = Just x
      remitter _ = Nothing

_ArrowT :: Prism' Type ()
_ArrowT
  = prism' reviewer remitter
  where
      reviewer () = ArrowT
      remitter ArrowT = Just ()
      remitter _ = Nothing

#if MIN_VERSION_template_haskell(2,10,0)
_EqualityT :: Prism' Type ()
_EqualityT
  = prism' reviewer remitter
  where
      reviewer () = EqualityT
      remitter EqualityT = Just ()
      remitter _ = Nothing
#endif

_ListT :: Prism' Type ()
_ListT
  = prism' reviewer remitter
  where
      reviewer () = ListT
      remitter ListT = Just ()
      remitter _ = Nothing

#if MIN_VERSION_template_haskell(2,8,0)
_PromotedTupleT :: Prism' Type Int
_PromotedTupleT
  = prism' reviewer remitter
  where
      reviewer = PromotedTupleT
      remitter (PromotedTupleT x) = Just x
      remitter _ = Nothing

_PromotedNilT :: Prism' Type ()
_PromotedNilT
  = prism' reviewer remitter
  where
      reviewer () = PromotedNilT
      remitter PromotedNilT = Just ()
      remitter _ = Nothing

_PromotedConsT :: Prism' Type ()
_PromotedConsT
  = prism' reviewer remitter
  where
      reviewer () = PromotedConsT
      remitter PromotedConsT = Just ()
      remitter _ = Nothing

_StarT :: Prism' Type ()
_StarT
  = prism' reviewer remitter
  where
      reviewer () = StarT
      remitter StarT = Just ()
      remitter _ = Nothing

_ConstraintT :: Prism' Type ()
_ConstraintT
  = prism' reviewer remitter
  where
      reviewer () = ConstraintT
      remitter ConstraintT = Just ()
      remitter _ = Nothing

_LitT :: Prism' Type TyLit
_LitT
  = prism' reviewer remitter
  where
      reviewer = LitT
      remitter (LitT x) = Just x
      remitter _ = Nothing
#endif

_PlainTV :: Prism' TyVarBndr Name
_PlainTV
  = prism' reviewer remitter
  where
      reviewer = PlainTV
      remitter (PlainTV x) = Just x
      remitter _ = Nothing

_KindedTV :: Prism' TyVarBndr (Name, Kind)
_KindedTV
  = prism' reviewer remitter
  where
      reviewer (x, y) = KindedTV x y
      remitter (KindedTV x y) = Just (x, y)
      remitter _ = Nothing

#if MIN_VERSION_template_haskell(2,8,0)
_NumTyLit :: Prism' TyLit Integer
_NumTyLit
  = prism' reviewer remitter
  where
      reviewer = NumTyLit
      remitter (NumTyLit x) = Just x
      remitter _ = Nothing

_StrTyLit :: Prism' TyLit String
_StrTyLit
  = prism' reviewer remitter
  where
      reviewer = StrTyLit
      remitter (StrTyLit x) = Just x
      remitter _ = Nothing
#endif

#if !MIN_VERSION_template_haskell(2,10,0)
_ClassP :: Prism' Pred (Name, [Type])
_ClassP
  = prism' reviewer remitter
  where
      reviewer (x, y) = ClassP x y
      remitter (ClassP x y) = Just (x, y)
      remitter _ = Nothing

_EqualP :: Prism' Pred (Type, Type)
_EqualP
  = prism' reviewer remitter
  where
      reviewer (x, y) = EqualP x y
      remitter (EqualP x y) = Just (x, y)
      remitter _ = Nothing
#endif

#if MIN_VERSION_template_haskell(2,9,0)
_NominalR :: Prism' Role ()
_NominalR
  = prism' reviewer remitter
  where
      reviewer () = NominalR
      remitter NominalR = Just ()
      remitter _ = Nothing

_RepresentationalR :: Prism' Role ()
_RepresentationalR
  = prism' reviewer remitter
  where
      reviewer () = RepresentationalR
      remitter RepresentationalR = Just ()
      remitter _ = Nothing

_PhantomR :: Prism' Role ()
_PhantomR
  = prism' reviewer remitter
  where
      reviewer () = PhantomR
      remitter PhantomR = Just ()
      remitter _ = Nothing

_InferR :: Prism' Role ()
_InferR
  = prism' reviewer remitter
  where
      reviewer () = InferR
      remitter InferR = Just ()
      remitter _ = Nothing
#endif
