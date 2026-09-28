Plan du site — Réservation de places de parking
Légende des accès
🌐 Public — accessible sans connexion
👤 Utilisateur — nécessite une session authentifiée (rôle `user`)
🛡️ Administrateur — nécessite une session authentifiée (rôle `admin`)
⚙️ API — endpoint appelé en arrière-plan (AJAX/fetch), pas une page
---
1. Espace public (non authentifié)
URL	Description
`/login`	Page de connexion (email + mot de passe)
`/register`	Formulaire de demande de compte — crée un compte en attente, validé ensuite par un admin
`/forgot-password`	Formulaire "mot de passe oublié" (saisie de l'email)
`/reset-password/:token`	Formulaire de nouveau mot de passe, avec jeton envoyé par email
> ⚠️ Le cahier des charges précise que les inscriptions doivent être **validées ou créées par un administrateur**. `/register` ne crée donc pas un compte actif : elle crée une demande que l'admin valide depuis `/admin/users`.
---
2. Espace utilisateur — 👤 (rôle `user`)
URL	Description
`/dashboard`	Page d'accueil utilisateur : statut actuel (place attribuée, en file d'attente, ou aucune demande), avec bouton "Demander une place"
`/dashboard/history`	Historique des places précédemment attribuées à l'utilisateur
`/dashboard/queue`	Détail de la position dans la file d'attente (si applicable)
`/account`	Informations du compte
`/account/password`	Modification du mot de passe
`/logout`	Déconnexion (action, redirige vers `/login`)
Actions déclenchées depuis `/dashboard` (pas de page dédiée, juste un bouton) :
Demander une réservation → attribution aléatoire immédiate ou mise en file d'attente
Fermer sa réservation en cours avant expiration
---
3. Espace administrateur — 🛡️ (rôle `admin`)
URL	Description
`/admin`	Tableau de bord : vue d'ensemble (places libres/occupées, taille de la file d'attente, demandes en attente de validation)
`/admin/users`	Liste des utilisateurs : création, validation des inscriptions, édition, réinitialisation de mot de passe
`/admin/users/:id`	Détail / édition d'un utilisateur
`/admin/places`	Liste des places de parking : ajout, édition, suppression, changement de statut
`/admin/places/:id`	Détail / édition d'une place
`/admin/queue`	Consultation et édition de l'ordre de la file d'attente (modification manuelle de position)
`/admin/reservations`	Liste des réservations actives, avec attribution manuelle d'une place
`/admin/reservations/:id`	Détail d'une réservation (fermeture manuelle avant expiration)
`/admin/history`	Historique global de toutes les attributions de places
`/admin/settings`	Paramètres (durée par défaut d'expiration d'une réservation)
---
4. Documentation (accessible depuis l'application)
URL	Description
`/docs` ou `/help`	Documentation utilisateur, accessible depuis l'application (lien dans le header/footer)
---
5. API (backend, appelée en AJAX depuis les pages ci-dessus)
Méthode + URL	Description
`POST /api/auth/login`	Connexion
`POST /api/auth/logout`	Déconnexion
`POST /api/auth/register`	Création d'une demande de compte
`POST /api/auth/forgot-password`	Envoi du lien de réinitialisation
`POST /api/auth/reset-password`	Validation du nouveau mot de passe
`GET /api/me`	Infos de l'utilisateur connecté (place, statut, rang)
`POST /api/reservations`	Demander une place (attribution auto ou mise en file d'attente)
`DELETE /api/reservations/:id`	Fermer une réservation (par l'utilisateur ou l'admin)
`GET /api/queue/me`	Rang de l'utilisateur connecté dans la file d'attente
`GET /api/admin/users`	Liste des utilisateurs (admin)
`PUT /api/admin/users/:id`	Éditer un utilisateur / réinitialiser son mot de passe
`POST /api/admin/users/:id/validate`	Valider une demande d'inscription
`GET /api/admin/places`	Liste des places (admin)
`POST /api/admin/places`	Créer une place
`PUT /api/admin/places/:id`	Éditer une place
`DELETE /api/admin/places/:id`	Supprimer une place
`GET /api/admin/queue`	Liste de la file d'attente (admin)
`PUT /api/admin/queue/reorder`	Réordonner la file d'attente
`POST /api/admin/reservations/:id/assign`	Attribution manuelle d'une place
`GET /api/admin/history`	Historique global
---
Arborescence visuelle
```
/
├── login
├── register
├── forgot-password
├── reset-password/:token
│
├── dashboard                    [user]
│   ├── history                  [user]
│   └── queue                    [user]
├── account                      [user]
│   └── password                 [user]
├── logout                       [user]
│
├── admin                        [admin]
│   ├── users
│   │   └── :id
│   ├── places
│   │   └── :id
│   ├── queue
│   ├── reservations
│   │   └── :id
│   ├── history
│   └── settings
│
└── docs (aide)
```
---
Notes de sécurité (à documenter aussi dans la section 3.1 du cahier des charges)
Toutes les routes `/dashboard/*`, `/account/*` nécessitent une session valide → sinon redirection vers `/login`.
Toutes les routes `/admin/*` nécessitent une session valide avec rôle `admin` → sinon 403 ou redirection.
Toutes les routes API doivent revalider les droits côté serveur (ne jamais faire confiance au front).
