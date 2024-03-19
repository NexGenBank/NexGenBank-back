package prog4.hei.nexgenbank.nexgenbankback.repository;

import java.util.List;

public interface BasicRepository<T> {
    List<T> findAll();
    List<T> saveAll(List<T> toSave);
    T save(T toSave);
    T update(T toUpdate);
}
