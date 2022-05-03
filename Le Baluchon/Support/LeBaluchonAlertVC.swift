//
//  LeBaluchonAlertVC.swift
//  Le Baluchon
//
//  Created by Stéphane Rihet on 16/04/2022.
//

import Foundation

enum LeBaluchonAlertVC {
    case weatherErrorNetwork
    case translateErrorNetwork
    case currencyErrorNetwork
    case currencyInputInvalid

    public var title: String {
        switch self {
        case .weatherErrorNetwork, .translateErrorNetwork, .currencyErrorNetwork:
            return "Erreur"
        case .currencyInputInvalid:
            return "Montant invalide"
        }
    }

    public var message: String {
        switch self {
        case .weatherErrorNetwork:
            return "La récupération des données méteorologique a échouée, Merci de vérifier votre connexion"
        case .translateErrorNetwork:
            return "La traduction a échouée, Merci de vérifier votre connexion"
        case .currencyErrorNetwork:
            return "La conversion a échouée, Merci de vérifier votre connexion"
        case .currencyInputInvalid:
            return "Le montant indiqué ne peut pas être convertit"
        }
    }
}
