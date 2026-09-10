# 🎵 Music Store Database Analysis (MySQL)

## 📌 Project Overview
This repository contains a comprehensive **MySQL Data Analysis Project** for a digital music store database. The project involves constructing a 10-table relational database schema, populating initial business data, and executing complex analytical SQL queries to derive insights on revenue, customer buying habits, genre popularity, and top artists.

---

## 🗄️ Database Architecture & Schema
The database (`music_store`) comprises 10 relational tables structured around core business entities: sales, customers, employees, and media catalog.

```text
               ┌───────────────┐          ┌───────────────┐
               │    Artist     │          │   MediaType   │
               └───────┬───────┘          └───────┬───────┘
                       │ 1                        │ 1
                       │                          │
                       ▼ N                        ▼ N
┌───────────────┐     ┌───────────────┐          ┌───────────────┐     ┌───────────────┐
│     Genre     │──1──►     Album     │────1────►     Track     ◄──N──│ PlaylistTrack │
└───────────────┘     └───────────────┘          └───────┬───────┘     └───────┬───────┘
                                                         │ 1                   │ N
                                                         │                     │
                                                         ▼ N                   ▼ 1
┌───────────────┐     ┌───────────────┐          ┌───────────────┐     ┌───────────────┐
│   Employee    │──1──►   Customer    │────1────►   InvoiceLine  │     │   Playlist    │
└───────────────┘     └───────┬───────┘          └───────▲───────┘     └───────────────┘
                              │ 1                        │ N
                              │                          │
                              ▼ N                        │
                      ┌───────────────┐                  │
                      │    Invoice    │──────────────────┘
                      └───────────────┘ 1
