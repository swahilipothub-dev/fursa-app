class Jobs {
  final int id;
  final String title;
  final String description;
  final List<Skill> skills;
  final int applicants;
  final int vacancies;
  final Location location;
  final String type;
  final String status;
  final Company company;

  Jobs({
    required this.id,
    required this.title,
    required this.description,
    required this.skills,
    required this.applicants,
    required this.vacancies,
    required this.location,
    required this.type,
    required this.status,
    required this.company,
  });
  
}

class Skill {
  final int id;
  final String skill;

  Skill({
    required this.id,
    required this.skill,
  });
}

class Location {
  final int id;
  final String name;

  Location({
    required this.id,
    required this.name,
  });
}

class Company {
  final String name;
  final String? profilePic;

  Company({
    required this.name,
    this.profilePic,
  });
}
